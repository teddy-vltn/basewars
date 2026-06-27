BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

local function updateOrCreateFaction(factionData)
    if not factionData then return end

    local faction = Faction.new(
        factionData.Name,
        "",
        factionData.Color,
        factionData.Icon,
        factionData.Leader
    )

    faction.Members = factionData.Members or {}
    faction.Leader = factionData.Leader
    faction.LeaderName = factionData.LeaderName
    faction.Password = factionData.Password and "protected" or ""

    BaseWars.Faction.Factions[factionData.Name] = faction
end

local function refreshFactionMenu()
    if IsValid(BaseWars.Faction.Menu) then
        BaseWars.Faction.Menu:RefreshFactionData()
    end
end

net.Receive(BaseWars.Faction.Net.UpdateAll, function(len)
    local allFactionData = BaseWars.Net.Read(BaseWars.Faction.Net.UpdateAll).factions
    BaseWars.Faction.Factions = {}

    for _, factionData in pairs(allFactionData) do
        updateOrCreateFaction(factionData)
    end

    refreshFactionMenu()
end)

net.Receive(BaseWars.Faction.Net.Update, function(len)
    local factionData = BaseWars.Net.Read(BaseWars.Faction.Net.Update).faction
    updateOrCreateFaction(factionData)
    refreshFactionMenu()
end)

net.Receive(BaseWars.Faction.Net.Delete, function(len)
    local factionName = BaseWars.Net.Read(BaseWars.Faction.Net.Delete).name
    BaseWars.Faction.Factions[factionName] = nil
    refreshFactionMenu()
end)

net.Receive(BaseWars.Faction.Net.InviteReceived, function(len)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.InviteReceived)

    Derma_Query(
        data.leader .. " invited you to join " .. data.faction .. ".",
        BaseWars.Lang("FactionInvite"),
        BaseWars.Lang("Yes"),
        function()
            BaseWars.Faction.AcceptInvite(data.faction)
        end,
        BaseWars.Lang("No"),
        function()
            BaseWars.Faction.DeclineInvite(data.faction)
        end
    )
end)

local function sendFactionRequest(netEvent, data)
    BaseWars.Net.SendToServer(netEvent, data)
end

function BaseWars.Faction.TryJoinFaction(name, password)
    sendFactionRequest(BaseWars.Faction.Net.Join, { name = name, password = password or "" })
end

function BaseWars.Faction.TryLeaveFaction(name)
    sendFactionRequest(BaseWars.Faction.Net.Leave, { name = name or "" })
end

function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
    sendFactionRequest(BaseWars.Faction.Net.Create, { name = name, password = password or "", color = color, icon = icon })
end

function BaseWars.Faction.TryKickPlayer(target)
    sendFactionRequest(BaseWars.Faction.Net.Kick, { target = target })
end

function BaseWars.Faction.TryInvitePlayer(target)
    sendFactionRequest(BaseWars.Faction.Net.Invite, { target = target })
end

function BaseWars.Faction.AcceptInvite(factionName)
    sendFactionRequest(BaseWars.Faction.Net.AcceptInvite, { faction = factionName })
end

function BaseWars.Faction.DeclineInvite(factionName)
    sendFactionRequest(BaseWars.Faction.Net.DeclineInvite, { faction = factionName })
end
