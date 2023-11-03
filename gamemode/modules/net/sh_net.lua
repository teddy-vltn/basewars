BaseWars = BaseWars or {}
BaseWars.Net = BaseWars.Net or {}

BaseWars.Net.Vars = {
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