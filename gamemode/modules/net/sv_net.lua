BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

/*
    @description
    Broadcast a network message to all players.

    @param {string} msgType - The network message type.
    @param {table} data - The data to send.
*/
function BaseWars.Net.Broadcast(msgType, data)
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Broadcast()

    BaseWars.Log("Broadcasted net message: " .. msgType)
end

/*
    @description
    Send a network message to a player.

    @param {Player} ply - The player to send the message to.
    @param {string} msgType - The network message type.
    @param {table} data - The data to send.
*/
function BaseWars.Net.SendToPlayer(ply, msgType, data)
    if not IsValid(ply) then return end

    BaseWars.Log("Sending net message: " .. msgType .. " to " .. ply:Nick())

    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.Send(ply)
end

/*
    @description
    Send a network message to a group of players.

    @param {table} group - The group of players to send the message to.
    @param {string} msgType - The network message type.
    @param {table} data - The data to send.
*/
function BaseWars.Net.SendToGroup(group, msgType, data)
    for _, ply in pairs(group) do
        BaseWars.Net.SendToPlayer(_, msgType, data)
    end
end

