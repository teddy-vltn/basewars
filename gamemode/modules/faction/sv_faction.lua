BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}

local Player = FindMetaTable("Player")

/*
    @description
    Sets the specified player as the leader of the faction.

    @param {Player} leader - The player entity to set as the leader of the faction.
*/
function Faction:SetLeader(leader)
    self.Leader = leader
end

/*
    @description
    Sets the faction for the player. If a faction object is provided, it uses the faction's name.

    @param {string|table} faction - The faction name or faction table to associate with the player.
*/
function Player:SetFaction(faction)
    local factionName = type(faction) == "table" and faction:GetName() or faction
    self:SetNWString("Faction", factionName)
end

/*
    @description
    Initializes the factions system, ensuring the factions table is set up and synchronizes factions.
*/
function BaseWars.Faction.Initialize() -- Initialisation
    BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

    BaseWars.Faction.SyncFactions()
end

local function ValidateFaction(name, password, color, icon)
    local validName, nameErr = BaseWars.Faction.ValidateName(name)
    if not validName then return false, nameErr end

    local validPassword, passwordErr = BaseWars.Faction.ValidatePassword(password)
    if not validPassword then return false, passwordErr end

    local validColor, colorErr = BaseWars.Faction.ValidateColor(color)
    if not validColor then return false, colorErr end

    local validIcon, iconErr = BaseWars.Faction.ValidateIcon(icon)
    if not validIcon then return false, iconErr end

    return true
end

/*
    @description
    Attempts to create a new faction with the provided parameters and sets the leader.

    @param {string} name - The unique name of the faction.
    @param {string} password - The password for the faction, if any.
    @param {Color} color - The color associated with the faction.
    @param {string} icon - The icon representing the faction.
    @param {Player} leader - The player entity to set as the initial leader of the faction.

    @return {boolean, string} A status indicating success or failure, and a message explaining the result.
*/
function BaseWars.Faction.CreateFaction(name, password, color, icon, leader)

    BaseWars.Log("Trying creating faction " .. name .. " with leader " .. leader:Nick())

    if BaseWars.Faction.Exists(name) then return false, "Faction already exists" end
    if BaseWars.Faction.GetFactionByMember(leader) then return false, "You are already in a faction" end

    local valid, err = ValidateFaction(name, password, color, icon)
    if not valid then return false, err end

    local faction = Faction.new(name, password, color, icon, leader)
    BaseWars.Faction.Factions[name] = faction

    -- Set the player's faction
    BaseWars.Faction.JoinFaction(leader, name, password)

    -- Sync the faction information
    BaseWars.Faction.SyncFaction(faction)

    return true, "Successfully created faction"
end

-- Handle networked requests for creating a faction
net.Receive(BaseWars.Faction.Net.Create, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.Create)

    local status, message = BaseWars.Faction.CreateFaction(data.name, data.password, data.color, data.icon, ply)

    BaseWars.Log("Status " .. tostring(status) .. " message " .. message .. " for " .. ply:Nick() .. " creating faction " .. data.name)

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

/*
    @description
    Synchronizes all faction data with a specific player or all players if no player is specified.

    @param {Player} ply - The player to synchronize with. If nil, synchronizes with all players.
*/
function BaseWars.Faction.SyncFactions(ply)

    local factions = {}
    for name, faction in pairs(BaseWars.Faction.Factions) do
        factions[name] = copyFactionForClientSend(faction)
    end

    BaseWars.Log("Syncing factions with " .. (IsValid(ply) and ply:Nick() or "everyone"))

    BaseWars.Net.SendToPlayer(ply, "BaseWars_UpdateFactions", {
        factions = factions
    })
        
end

/*
    @description
    Synchronizes a specific faction's details with all players.

    @param {table} faction - The faction table containing faction details to synchronize.
*/
function BaseWars.Faction.SyncFaction(faction)
    local copyTable = copyFactionForClientSend(faction)

    BaseWars.Log("Syncing faction " .. faction:GetName())

    BaseWars.Net.Broadcast("BaseWars_UpdateFaction", {
        name = faction:GetName(),
        faction = copyTable
    })
end

/*
    @description
    Handles the process of a player attempting to join a faction, including password verification.

    @param {Player} ply - The player attempting to join the faction.
    @param {string} factionName - The name of the faction the player is attempting to join.
    @param {string} password - The password provided by the player for the faction, if required.

    @return {boolean, string} A status indicating success or failure, and a message explaining the result.
*/
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
net.Receive(BaseWars.Faction.Net.Join, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.Join)

    local status, message = BaseWars.Faction.JoinFaction(ply, data.name, data.password)

    BaseWars.Notify.Send(ply, "Rejoindre une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

/*
    @description
    Handles the process of a player leaving their current faction.

    @param {Player} ply - The player leaving the faction.

    @return {boolean, string} A status indicating success or failure, and a message explaining the result.
*/
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

/*
    @description
    Deletes a faction with the given name from the server.

    @param {string} name - The name of the faction to delete.

    @return {boolean, string} A status indicating success or failure, and a message explaining the result.
*/
function BaseWars.Faction.DeleteFaction(name)
    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false, "Faction does not exist" end

    BaseWars.Log("Deleting faction " .. name .. " made by " .. factionTable.Leader:Nick())

    BaseWars.Net.Broadcast(BaseWars.Faction.Net.Delete, {
        name = name
    })

    BaseWars.Faction.Factions[name] = nil

    return true, "Successfully deleted faction"
end

-- Handle networked requests for leaving a faction
net.Receive(BaseWars.Faction.Net.Leave, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.Leave)

    local status, message = BaseWars.Faction.LeaveFaction(ply)

    BaseWars.Notify.Send(ply, "Quitter une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)


/*
    @description
    Sets the faction for a player directly, optionally setting them as the leader.

    @param {Player} ply - The player to set the faction for.
    @param {string} name - The name of the faction to set.
    @param {boolean} [leader] - Whether the player should also be set as the leader of the faction.

    @return {boolean, string} A status indicating success or failure, and a message explaining the result.
*/
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

hook.Add("PlayerInitialSpawn", "BaseWars_FactionSync", function(ply)
   -- BaseWars.Faction.CreateFaction("Default", "yes", BaseWars.Color("RED"), "icon16/gun.png", ply)

    BaseWars.Faction.SyncFactions(ply)
end)
