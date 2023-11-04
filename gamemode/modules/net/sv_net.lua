BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

-- Send a network message to all players
function BaseWars.Net.Broadcast(msgType, data)
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Broadcast()
end

-- Send a network message to a specific player
function BaseWars.Net.SendToPlayer(ply, msgType, data)
    if not IsValid(ply) then return end
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Send(ply)
end

-- Send a network message to a group of players
function BaseWars.Net.SendToGroup(group, msgType, data)
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Send(group)
end

