BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

net.Receive(BaseWars.Faction.Net.UpdateAll, function(len)
    local factions = BaseWars.Net.Read(BaseWars.Faction.Net.UpdateAll)

    BaseWars.Log("Received factions update from server.")

    factions = factions.factions

    -- Transform them into Faction objects
    for name, factionData in pairs(factions) do
        BaseWars.Faction.Factions[name] = Faction.new(factionData.Name, factionData.Password, factionData.Color, factionData.Icon, factionData.Leader)
        BaseWars.Faction.Factions[name].Members = factionData.Members
    end

    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end)

net.Receive(BaseWars.Faction.Net.Update, function(len)
    local factionData = BaseWars.Net.Read(BaseWars.Faction.Net.Update).faction

    BaseWars.Faction.Factions[factionData.Name] = Faction.new(factionData.Name, factionData.Password, factionData.Color, factionData.Icon, factionData.Leader)
    BaseWars.Faction.Factions[factionData.Name].Members = factionData.Members

    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end)

net.Receive(BaseWars.Faction.Net.Delete, function(len)
    local name = BaseWars.Net.Read(BaseWars.Faction.Net.Delete).name
    BaseWars.Faction.Factions[name] = nil

    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end)

function BaseWars.Faction.TryJoinFaction(name, password)
    BaseWars.Net.SendToServer(BaseWars.Faction.Net.Join, {name = name, password = password})
end

function BaseWars.Faction.TryLeaveFaction(name)
    BaseWars.Net.SendToServer(BaseWars.Faction.Net.Leave, {name = name})
end

function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
    BaseWars.Net.SendToServer(BaseWars.Faction.Net.Create, {name = name, password = password, color = color, icon = icon})
end
