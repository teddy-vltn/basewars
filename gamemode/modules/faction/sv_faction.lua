-- Ensure the BaseWars and BaseWars.Faction tables exist or initialize them
BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}

-- Retrieve the Player's meta table for later manipulation
local Player = FindMetaTable("Player")

-- Function to set a player's faction. This is stored as a networked string.
function Player:SetFaction(faction)
    self:SetNWString("Faction", faction)
end

-- Function to initialize the factions. Primarily, this ensures the Factions table is initialized and synced.
function BaseWars.Faction.Initialize() -- Initialisation
    BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}
    BaseWars.Faction.SyncFactions()
end

-- Register a network string for creating factions
util.AddNetworkString("BaseWars_CreateFaction")
-- Function to create a new faction with the given name, leader, password, and icon.
function BaseWars.Faction.CreateFaction(name, leader, password, color, icon)
    if not name or name == "" then return false, "Invalid name" end

    -- Remove all non-alphanumeric characters except spaces and accents versions of letters
    name = name:gsub("[^%w%sÀ-ÖØ-öø-ÿ]", "")

    -- do some simple length checks
    if #name > 32 then return false, "Name is too long" end
    if #name < 3 then return false, "Name is too short" end

    if #password > 32 then return false, "Password is too long" end

    if BaseWars.Faction.Factions[name] then return false, "Faction already exists" end

    if BaseWars.Faction.GetFactionByMember(leader) then return false, "You are already in a faction" end

    BaseWars.Faction.Factions[name] = {
        Name = name,
        Leader = leader,
        Color = color or Color(255, 255, 255),
        Members = { [leader] = true },
        Password = password or "",
        Icon = icon or "icon16/group.png"
    }

    BaseWars.Faction.SetFaction(leader, name, true)

    BaseWars.Faction.SyncFaction(name, BaseWars.Faction.Factions[name]) -- Synchronisation
    return true, "Successfully created faction"
end

-- Handle networked requests for creating a faction
net.Receive("BaseWars_CreateFaction", function(len, ply)
    local factionName = net.ReadString()
    local factionPassword = net.ReadString()
    local factionColor = net.ReadColor()
    local factionIcon = net.ReadString()

    local status, message = BaseWars.Faction.CreateFaction(factionName, ply, factionPassword, factionIcon)

    BaseWars.Notify.Send(ply, "Créer une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

-- Register a network string for updating all factions
util.AddNetworkString("BaseWars_UpdateFactions")
-- Function to sync all factions with a specific player or all players.
function BaseWars.Faction.SyncFactions(ply)
    local factions = table.Copy(BaseWars.Faction.Factions) -- Copy the table for manipulation
    for k, v in pairs(factions) do
        v.Password = BaseWars.Faction.HasFactionPassword(k) -- Convert passwords to boolean
    end

    net.Start("BaseWars_UpdateFactions")
        net.WriteTable(factions)
    net.Send(ply)
end

-- Register a network string for updating a specific faction
util.AddNetworkString("BaseWars_UpdateFaction")
-- Function to sync a specific faction's details across all players.
function BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation
    local copyTable = table.Copy(factionTable) -- Copy the table for manipulation
    copyTable.Password = BaseWars.Faction.HasFactionPassword(name) -- Convert password to boolean

    net.Start("BaseWars_UpdateFaction")
        net.WriteString(name)
        net.WriteTable(copyTable)
    net.Broadcast()
end

-- Register a network string for a player joining a faction
util.AddNetworkString("BaseWars_JoinFaction")
-- Function to handle a player attempting to join a faction.
function BaseWars.Faction.JoinFaction(ply, name, password)
    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false, "Faction does not exist" end

    if factionTable.Password ~= "" and factionTable.Password ~= password then return false, "Incorrect password" end

    local currentFaction = ply:GetFaction()
    if currentFaction then
        BaseWars.Faction.LeaveFaction(ply) -- If player is in another faction, make them leave it
    end

    factionTable.Members[ply] = true
    ply:SetFaction(name)
    BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation

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

    PrintTable(factionTable.Members)

    BaseWars.Faction.SyncFaction(factionTable.Name, factionTable)

    -- if there are no more members, delete the faction
    if table.Count(factionTable.Members) == 0 then
        BaseWars.Faction.DeleteFaction(factionTable.Name)
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

    BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation

    return true
end
