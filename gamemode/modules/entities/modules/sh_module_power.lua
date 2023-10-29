local BW_POWER_MODULE = {}

BW_POWER_MODULE.Name = "Power"
BW_POWER_MODULE.Description = "Allows entity to use power"

BW_POWER_MODULE.NetworkVars = {
    {"PowerUsage", 0, "Int"},
    {"PowerCapacity", 0, "Int"},
    {"Power", 0, "Int"}
}

function BW_POWER_MODULE.Initialize(ent)
    ent.UsePower = true

    print("Power module initialized")
end

function BW_POWER_MODULE.OnThink(ent)
    if CLIENT then return end

    local power = ent:GetPower()
    local powerUsage = ent:GetPowerUsage()
    local powerCapacity = ent:GetPowerCapacity()

    if power > 0 then
        ent:SetPower(power - powerUsage)
    else
        ent:SetPower(0)
    end

    if power > powerCapacity then
        ent:SetPower(powerCapacity)
    end

end

function BW_POWER_MODULE.ReceivePower(ent, power)
    local actualPower = ent:GetPower()
    local powerCapacity = ent:GetPowerCapacity()

    if actualPower + power > powerCapacity then
        ent:SetPower(powerCapacity)
    else
        ent:SetPower(actualPower + power)
    end
end

function BW_POWER_MODULE.DrainPower(ent, power)
    local power = ent:GetPower()

    if power - power < 0 then
        ent:SetPower(0)
    else
        ent:SetPower(power - power)
    end
end

BaseWars.Entity.Modules:Add(BW_POWER_MODULE.Name, BW_POWER_MODULE)