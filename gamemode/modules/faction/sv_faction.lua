BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}

-- Retrieve the Player's meta table for later manipulation
local Player = FindMetaTable("Player")

function Faction:SetLeader(leader)
    self.Leader = leader
end

function Player:SetFaction(faction)
    -- Make sure to pass only the faction name if a faction object is given
    local factionName = type(faction) == "table" and faction:GetName() or faction
    self:SetNWString("Faction", factionName)
end

-- Function to initialize the factions. Primarily, this ensures the Factions table is initialized and synced.
function BaseWars.Faction.Initialize() -- Initialisation
    BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

    BaseWars.Faction.SyncFactions()
end

-- Register a network string for creating factions
util.AddNetworkString("BaseWars_CreateFaction")
-- Function to create a new faction with the given name, leader, password, and icon.
function BaseWars.Faction.CreateFaction(name, password, color, icon, leader)
    if not name or name == "" then return false, "Invalid name" end

    -- Remove all non-alphanumeric characters except spaces and accents versions of letters
    name = name:gsub("[^%w%sÀ-ÖØ-öø-ÿ]", "")

    -- do some simple length checks
    if #name > 32 then return false, "Name is too long" end
    if #name < 3 then return false, "Name is too short" end

    if #password > 32 then return false, "Password is too long" end

    if BaseWars.Faction.Factions[name] then return false, "Faction already exists" end

    if BaseWars.Faction.GetFactionByMember(leader) then return false, "You are already in a faction" end

    BaseWars.Log("Creating faction " .. name .. " with leader " .. leader:Nick())

    -- Create the faction and add the leader to it
    local faction = Faction.new(name, password, color, icon, leader)

    -- Add the faction to the list of factions
    BaseWars.Faction.Factions[name] = faction

    -- Set the player's faction
    BaseWars.Faction.JoinFaction(leader, name, password)

    -- Sync the faction information
    BaseWars.Faction.SyncFaction(faction)

    return true, "Successfully created faction"
end

-- Handle networked requests for creating a faction
net.Receive("BaseWars_CreateFaction", function(len, ply)
    local factionName = net.ReadString()
    local factionPassword = net.ReadString()
    local factionColor = net.ReadColor()
    local factionIcon = net.ReadString()

    local status, message = BaseWars.Faction.CreateFaction(factionName, factionPassword, factionColor, factionIcon, ply)

    BaseWars.Notify.Send(ply, "Créer une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

local function copyFactionForClientSend(faction)
    if not faction then return end

    return {
        Name = faction:GetName(),
        Members = faction:GetMembers(),
        Password = faction:HasPassword(),
        Color = faction:GetColor(),
        Icon = faction:GetIcon(),
        Leader = faction:GetLeader()
    }
end

-- Register a network string for updating all factions
util.AddNetworkString("BaseWars_UpdateFactions")
-- Function to sync all factions with a specific player or all players.
function BaseWars.Faction.SyncFactions(ply)

    local factions = {}
    for name, faction in pairs(BaseWars.Faction.Factions) do
        factions[name] = copyFactionForClientSend(faction)
    end

    BaseWars.Log("Syncing factions with " .. (IsValid(ply) and ply:Nick() or "everyone"))

    net.Start("BaseWars_UpdateFactions")
        net.WriteTable(factions)
    net.Send(ply)
end

-- Register a network string for updating a specific faction
util.AddNetworkString("BaseWars_UpdateFaction")
-- Function to sync a specific faction's details across all players.
function BaseWars.Faction.SyncFaction(faction)
    local copyTable = copyFactionForClientSend(faction)

    BaseWars.Log("Syncing faction " .. faction:GetName())

    net.Start("BaseWars_UpdateFaction")
        net.WriteString(faction:GetName())
        net.WriteTable(copyTable)
    net.Broadcast()
end

-- Register a network string for a player joining a faction
util.AddNetworkString("BaseWars_JoinFaction")
-- Function to handle a player attempting to join a faction.
function BaseWars.Faction.JoinFaction(ply, factionName, password)
    local faction = BaseWars.Faction.Factions[factionName]
    if not faction then return false, "Faction does not exist" end

    if faction:HasPassword() and faction:GetPassword() ~= password then
        return false, "Incorrect password"
    end

       -- Leave the current faction if already in one
    local currentFaction = ply:GetFaction()
    if currentFaction and BaseWars.Faction.Factions[currentFaction] then
        BaseWars.Faction.LeaveFaction(ply)
    end

    -- Join the new faction
    faction.Members[ply] = true
    ply:SetFaction(faction)

    -- Sync the faction information
    BaseWars.Faction.SyncFaction(faction)

    return true, "Successfully joined faction"
end

-- Handle networked requests for joining a faction
net.Receive("BaseWars_JoinFaction", function(len, ply)
    local factionName = net.ReadString()
    local factionTable = BaseWars.Faction.GetFaction(factionName)
    if not factionTable then return end

    local password = net.ReadString()

    local status, message = BaseWars.Faction.JoinFaction(ply, factionName, password)

    BaseWars.Notify.Send(ply, "Rejoindre une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

-- Register a network string for a player leaving a faction
util.AddNetworkString("BaseWars_LeaveFaction")
-- Function to handle a player leaving a faction.
function BaseWars.Faction.LeaveFaction(ply)
    local factionTable = BaseWars.Faction.GetFactionByMember(ply)
    if not factionTable then return false, "You are not in a faction" end

    factionTable.Members[ply] = nil
    ply:SetFaction("")

    -- if there are no more members, delete the faction
    if table.Count(factionTable.Members) == 0 then
        BaseWars.Faction.DeleteFaction(factionTable.Name)
    else 
        BaseWars.Faction.SyncFaction(factionTable.Name, factionTable)
    end

    return true, "Successfully left faction"
end

util.AddNetworkString("BaseWars_FactionIsDeleted")
-- Function to delete a faction.
function BaseWars.Faction.DeleteFaction(name)
    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false, "Faction does not exist" end

    net.Start("BaseWars_FactionIsDeleted")
        net.WriteString(name)
    net.Broadcast()

    BaseWars.Faction.Factions[name] = nil

    return true, "Successfully deleted faction"
end

-- Handle networked requests for leaving a faction
net.Receive("BaseWars_LeaveFaction", function(len, ply)
    local factionTable = BaseWars.Faction.GetFactionByMember(ply)
    if not factionTable then return end

    local status, message = BaseWars.Faction.LeaveFaction(ply)

    BaseWars.Notify.Send(ply, "Quitter une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

-- Function to set a player's faction directly, without the need for them to join.
function BaseWars.Faction.SetFaction(ply, name, leader)
    if not IsValid(ply) then return false, "Invalid player" end

    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false, "Faction does not exist" end

    factionTable.Members[ply] = true
    ply:SetFaction(name)

    if leader then
        factionTable.Leader = ply
    end

    BaseWars.Faction.SyncFaction(name, factionTable)

    return true
end
