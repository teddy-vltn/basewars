BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

local NetVars = BaseWars.Net.Vars

-- Send a network message to server
local function SendNetMessageToServer(msgType, data)
    net.Start(msgType)
    for k, v in pairs(data) do
        local writeFunc = NetVars[type(v)]
        if writeFunc then
            writeFunc(v)
        else
            error("Unhandled data type: " .. type(v))
        end
    end
    net.SendToServer()
end
BaseWars.Net.SendToServer = SendNetMessageToServer