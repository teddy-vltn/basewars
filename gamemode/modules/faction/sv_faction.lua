BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}

local Player = FindMetaTable("Player")

function BaseWars.Faction.Initialize() -- Initialisation
    BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

    BaseWars.Faction.SyncFactions()
end

util.AddNetworkString("BaseWars_CreateFaction")
function BaseWars.Faction.CreateFaction(name, leader, password, icon)
    if BaseWars.Faction.Factions[name] then return false, "Faction already exists" end

    BaseWars.Faction.Factions[name] = {
        Leader = leader,
        Members = {leader = true},
        Password = password or "",
        Icon = icon or "icon16/group.png"
    }

    BaseWars.Faction.SyncFaction(name, BaseWars.Faction.Factions[name]) -- Synchronisation
    return true
end

util.AddNetworkString("BaseWars_UpdateFactions")
function BaseWars.Faction.SyncFactions(ply)

    -- make a copy of the table
    local factions = table.Copy(BaseWars.Faction.Factions)

    -- turn the passwords into a boolean
    for k, v in pairs(factions) do
        v.Password = v.Password ~= ""
    end

    net.Start("BaseWars_UpdateFactions")
        net.WriteTable(factions)
    net.Send(ply)
end

util.AddNetworkString("BaseWars_UpdateFaction")
function BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation

    -- make a copy of the table
    local copyTable = table.Copy(factionTable)

    -- turn the password into a boolean
    copyTable.Password = factionTable.Password ~= ""

    net.Start("BaseWars_UpdateFaction")
        net.WriteString(name)
        net.WriteTable(copyTable)
    net.Broadcast()
end

util.AddNetworkString("BaseWars_JoinFaction")
function BaseWars.Faction.JoinFaction(ply, name, password)
    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false, "Faction does not exist" end

    if factionTable.Password ~= "" and factionTable.Password ~= password then return false, "Incorrect password" end

    factionTable.Members[ply] = true
    ply.Faction = factionTable

    -- send to player that they joined the faction
    net.Start("BaseWars_JoinFaction")
        net.WriteEntity(ply)
        net.WriteString(name)
    net.Send(ply)

    BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation

    return true, "Successfully joined faction"
end

-- net receive join faction
net.Receive("BaseWars_JoinFaction", function(len, ply)
    local factionName = net.ReadString()
    local factionTable = BaseWars.Faction.GetFaction(factionName)
    if not factionTable then return end

    local password = net.ReadString()

    local status, message = BaseWars.Faction.JoinFaction(ply, factionName, password)

    BaseWars.Notify.Send(ply, "Rejoindre une faction", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

function BaseWars.Faction.SetFaction(ply, name)
    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false, "Faction does not exist" end

    factionTable.Members[ply] = true
    ply.Faction = factionTable

    BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation

    return true
end
