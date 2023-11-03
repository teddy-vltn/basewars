BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

-- Send a network message to all players
local function Broadcast(msgType, data)
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Broadcast()
end
BaseWars.Net.Broadcast = Broadcast

-- Send a network message to a specific player
local function SendToPlayer(ply, msgType, data)
    if not IsValid(ply) then return end
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Send(ply)
end
BaseWars.Net.SendToPlayer = SendToPlayer

-- Send a network message to a group of players
local function SendToGroup(group, msgType, data)
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Send(group)
end
BaseWars.Net.SendToGroup = SendToGroup
