BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

-- Define a table where each data type is associated with its corresponding net.Write* function
local NetVars = {
    ["number"] = function(v)
        if math.floor(v) == v then
            net.WriteInt(v, 32)
        else
            net.WriteFloat(v)
        end
    end,
    ["string"] = function(v)
        net.WriteString(v)
    end,
    ["boolean"] = function(v)
        net.WriteBool(v)
    end,
    ["Entity"] = function(v)
        net.WriteEntity(v)
    end,
    -- Add more data types as needed
}

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