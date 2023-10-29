local BW_GENERATOR_MODULE = {}

BW_GENERATOR_MODULE.Name = "Generator"
BW_GENERATOR_MODULE.Description = "Allows you to generate electricity"

BW_GENERATOR_MODULE.NetworkVars = {
    {"PowerGeneration", 0, "Int"},
    {"PowerCapacity", 0, "Int"},
    {"Power", 0, "Int"}
}

function BW_GENERATOR_MODULE.Initialize(ent)
    print("Generator module initialized")
end

function BW_GENERATOR_MODULE.TransmitPowerToNearbyEntities(ent)
    local nearbyEntities = ents.FindInSphere(ent:GetPos(), 600)

    for _, toTransmit in pairs(nearbyEntities) do
        if toTransmit.UsePower and toTransmit != ent then
            local powerNeeded = toTransmit:GetPowerCapacity() - toTransmit:GetPower()
            local powerToTransmit = math.min(ent:GetPower(), powerNeeded)

            local powerModule = BaseWars.Entity.Modules:Get("Power")
            
            powerModule.ReceivePower(toTransmit, powerToTransmit)
            BW_GENERATOR_MODULE.DrainPower(ent, powerToTransmit)
        end
    end
end

function BW_GENERATOR_MODULE.DrainPower(ent, power)
    local actualPower = ent:GetPower()

    if actualPower - power < 0 then
        ent:SetPower(0)
    else
        ent:SetPower(actualPower - power)
    end
end

function BW_GENERATOR_MODULE.OnThink(ent)
    if CLIENT then return end

    local power = ent:GetPower()
    local powerGeneration = ent:GetPowerGeneration()

    if power < ent:GetPowerCapacity() then
        ent:SetPower(power + powerGeneration)
    else
        ent:SetPower(ent:GetPowerCapacity())
    end

    BW_GENERATOR_MODULE.TransmitPowerToNearbyEntities(ent)

end

BaseWars.Entity.Modules:Add(BW_GENERATOR_MODULE.Name, BW_GENERATOR_MODULE)