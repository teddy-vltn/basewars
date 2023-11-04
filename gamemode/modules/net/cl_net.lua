BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

-- Send a network message to server
local function SendToServer(msgType, data)
    net.Start(msgType)
    BaseWars.Net.Write(msgType, data)
    net.SendToServer()
end
BaseWars.Net.SendToServer = SendToServer
