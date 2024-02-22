BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

/*
    @description
    Send a network message to the server.

    @param {string} msgType - The network message type.
    @param {table} data - The data to send.
*/
function BaseWars.Net.SendToServer(msgType, data)

    if not msgType then
        BaseWars.Log("No message type specified")
        return
    end

    BaseWars.Log("Sending net message: " .. msgType .. " to server")

    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.SendToServer()
end
