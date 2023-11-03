BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

local NetVars = BaseWars.Net.Vars

-- Send a network message to all players
local function BroadcastNetMessage(msgType, data)
    net.Start(msgType)
    for k, v in pairs(data) do
        local writeFunc = NetVars[type(v)]
        if writeFunc then
            writeFunc(v)
        else
            error("Unhandled data type: " .. type(v))
        end
    end
    net.Broadcast()
end
BaseWars.Net.Broadcast = BroadcastNetMessage

-- Send a network message to a specific player
local function SendNetMessageToPlayer(ply, msgType, data)
    if not IsValid(ply) then return end
    net.Start(msgType)
    for k, v in pairs(data) do
        local writeFunc = NetVars[type(v)]
        if writeFunc then
            writeFunc(v)
        else
            error("Unhandled data type: " .. type(v))
        end
    end
    net.Send(ply)
end
BaseWars.Net.SendToPlayer = SendNetMessageToPlayer

-- Send a network message to a group of players
local function SendNetMessageToGroup(group, msgType, data)
    net.Start(msgType)
    for k, v in pairs(data) do
        local writeFunc = NetVars[type(v)]
        if writeFunc then
            writeFunc(v)
        else
            error("Unhandled data type: " .. type(v))
        end
    end
    net.Send(group)
end
BaseWars.Net.SendToGroup = SendNetMessageToGroup