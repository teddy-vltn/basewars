BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}

net.Receive("BaseWars_UpdateFactions", function()
    BaseWars.Faction.Factions = net.ReadTable()
end)

net.Receive("BaseWars_UpdateFaction", function()
    local factionName = net.ReadString()
    BaseWars.Faction.Factions[factionName] = net.ReadTable()

    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end)

net.Receive("BaseWars_FactionIsDeleted", function()
    local factionName = net.ReadString()
    BaseWars.Faction.Factions[factionName] = nil

    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end)

function BaseWars.Faction.TryJoinFaction(name, password)
    net.Start("BaseWars_JoinFaction")
        net.WriteString(name)
        net.WriteString(password)
    net.SendToServer()
end

function BaseWars.Faction.TryLeaveFaction(name)
    net.Start("BaseWars_LeaveFaction")
        net.WriteString(name)
    net.SendToServer()
end

function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
    net.Start("BaseWars_CreateFaction")
        net.WriteString(name)
        net.WriteString(password)
        net.WriteColor(color)
        net.WriteString(icon)
    net.SendToServer()
end