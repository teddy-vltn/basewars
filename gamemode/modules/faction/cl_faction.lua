-- Ensuring the BaseWars and its nested tables are initialized
BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

-- Helper function to update or create a faction from data
local function updateOrCreateFaction(factionData)
    local faction = Faction.new(
        factionData.Name,
        factionData.Password,
        factionData.Color,
        factionData.Icon,
        factionData.Leader
    )
    faction.Members = factionData.Members
    BaseWars.Faction.Factions[factionData.Name] = faction
end

-- Helper function to refresh faction data on the menu if it's valid
local function refreshFactionMenu()
    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end

-- Receives updated data for all factions
net.Receive(BaseWars.Faction.Net.UpdateAll, function(len)
    local allFactionData = BaseWars.Net.Read(BaseWars.Faction.Net.UpdateAll).factions
    BaseWars.Log("Received factions update from server.")

    for name, factionData in pairs(allFactionData) do
        updateOrCreateFaction(factionData)
    end

    refreshFactionMenu()
end)

-- Receives updated data for a single faction
net.Receive(BaseWars.Faction.Net.Update, function(len)
    local factionData = BaseWars.Net.Read(BaseWars.Faction.Net.Update).faction
    updateOrCreateFaction(factionData)
    refreshFactionMenu()
end)

-- Handles the deletion of a faction
net.Receive(BaseWars.Faction.Net.Delete, function(len)
    local factionName = BaseWars.Net.Read(BaseWars.Faction.Net.Delete).name
    BaseWars.Faction.Factions[factionName] = nil
    refreshFactionMenu()
end)

-- Helper function to send a faction related request to the server
local function sendFactionRequest(netEvent, data)
    BaseWars.Net.SendToServer(netEvent, data)
end

-- Public functions to attempt faction related actions
function BaseWars.Faction.TryJoinFaction(name, password)
    sendFactionRequest(BaseWars.Faction.Net.Join, {name = name, password = password})
end

function BaseWars.Faction.TryLeaveFaction(name)
    sendFactionRequest(BaseWars.Faction.Net.Leave, {name = name})
end

function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
    sendFactionRequest(BaseWars.Faction.Net.Create, {name = name, password = password, color = color, icon = icon})
end
