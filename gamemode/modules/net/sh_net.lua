BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

BaseWars.Net.WriteVars = {
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
    ["table"] = function(v)
        net.WriteTable(v)
    end,
    ["color"] = function(v)
        net.WriteColor(v)
    end,
}

BaseWars.Net.ReadVars = {
    ["number"] = function()
        return net.ReadInt(32)
    end,
    ["string"] = function()
        return net.ReadString()
    end,
    ["boolean"] = function()
        return net.ReadBool()
    end,
    ["Entity"] = function()
        return net.ReadEntity()
    end,
    ["table"] = function()
        return net.ReadTable()
    end,
    ["color"] = function()
        return net.ReadColor()
    end,
}

-- example of use : BaseWars.Net.Register("BaseWars_BuyEntity", { 
--     uuid = "string",
-- })
local function RegisterNetMessageAndStructure(msgType, structure)
    if BaseWars.Net[msgType] then
        BaseWars.Log("Overwriting net message: " .. msgType)
    end

    if SERVER then
        util.AddNetworkString(msgType)
    end
    
    BaseWars.Net[msgType] = structure
end
BaseWars.Net.Register = RegisterNetMessageAndStructure

-- read a network message based on a structure
-- if the structure differs from the one registered, it will error
-- example of use : local data = BaseWars.Net.Read("BaseWars_BuyEntity")
-- data.uuid will contain the uuid of the entity to buy
local function ReadNetMessage(msgType)
    local structure = BaseWars.Net[msgType]

    if not structure then
        error("No structure registered for message type: " .. msgType)
    end

    local data = {}
    for k, v in pairs(structure) do
        local readFunc = BaseWars.Net.ReadVars[v]
        if readFunc then
            data[k] = readFunc()
        else
            BaseWars.Log("Unhandled data type: " .. v .. " for message type: " .. msgType)
        end
    end

    return data
end
BaseWars.Net.Read = ReadNetMessage

-- write a network message based on a structure
-- if the structure differs from the one registered, it will error
-- example of use : BaseWars.Net.Write("BaseWars_BuyEntity", {uuid = "1234"})
local function WriteNetMessage(msgType, data)
    local structure = BaseWars.Net[msgType]

    if not structure then
        error("No structure registered for message type: " .. msgType)
    end

    for k, v in pairs(structure) do
        local writeFunc = BaseWars.Net.WriteVars[v]
        if writeFunc then
            writeFunc(data[k])
        else
            BaseWars.Log("Unhandled data type: " .. v .. " for message type: " .. msgType)
        end
    end
end
BaseWars.Net.Write = WriteNetMessage
