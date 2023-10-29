BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}

net.Receive("BaseWars_UpdateFactions", function()
    BaseWars.Faction.Factions = net.ReadTable()
end)

net.Receive("BaseWars_UpdateFaction", function()
    local factionName = net.ReadString()
    BaseWars.Faction.Factions[factionName] = net.ReadTable()
end)

net.Receive("BaseWars_JoinFaction", function()
    local ply = net.ReadEntity()
    local factionName = net.ReadString()

    local factionTable = BaseWars.Faction.GetFaction(factionName)
    if not factionTable then return end

    ply.Faction = factionTable
end)

