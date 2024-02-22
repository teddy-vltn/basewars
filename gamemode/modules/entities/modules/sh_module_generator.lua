local BW_GENERATOR_MODULE = {}
BW_GENERATOR_MODULE.__index = BW_GENERATOR_MODULE

-- Constants
local MODULE_NAME = "Generator"
local MODULE_DESC = "Allows you to generate electricity"

-- Initialization
function BW_GENERATOR_MODULE.New()
    local self = setmetatable({}, BW_GENERATOR_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.LastTimeGenerated = CurTime()
    self.NetworkVars = {
        {"PowerGeneration", 0, "Int"},
        {"PowerCapacity", 0, "Int"},
        {"Power", 0, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_GENERATOR_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized
    print("Generator module initialized")
end

function BW_GENERATOR_MODULE:TransmitPowerToNearbyEntities(ent)
    local nearbyEntities = ents.FindInSphere(ent:GetPos(), 600)
    local entitiesNeedingPower = {}

    for _, nearbyEnt in ipairs(nearbyEntities) do
        if not IsValid(nearbyEnt) then continue end
        if not nearbyEnt.Modules then continue end
        if not nearbyEnt.GetPowerUsage then continue end
        if nearbyEnt == ent then continue end

        table.insert(entitiesNeedingPower, nearbyEnt)
    end

    if #entitiesNeedingPower == 0 then return end

    local power = ent:GetPower()
    local powerCapacity = ent:GetPowerCapacity()
    local powerGeneration = ent:GetPowerGeneration()

    local powerToTransmit = powerGeneration

    if power < powerGeneration then
        powerToTransmit = power
    end

    for _, nearbyEnt in ipairs(entitiesNeedingPower) do
        local powerNeeded = nearbyEnt:GetPowerCapacity() - nearbyEnt:GetPower()

        if powerNeeded > 0 then
            if powerToTransmit > powerNeeded then
                self:DrainPower(ent, powerNeeded)
                nearbyEnt:SetPower(nearbyEnt:GetPower() + powerNeeded)
                powerToTransmit = powerToTransmit - powerNeeded
            else
                self:DrainPower(ent, powerToTransmit)
                nearbyEnt:SetPower(nearbyEnt:GetPower() + powerToTransmit)
                powerToTransmit = 0
            end
        end
    end
end


function BW_GENERATOR_MODULE:DrainPower(ent, power)
    local actualPower = ent:GetPower()

    if actualPower - power < 0 then
        ent:SetPower(0)
    else
        ent:SetPower(actualPower - power)
    end
end

function BW_GENERATOR_MODULE:OnThink(ent)
    if CLIENT then return end

    if self.LastTimeGenerated + 1 > CurTime() then return end

    --self.LastTimeGenerated = CurTime()

    local power = ent:GetPower()
    local powerCapacity = ent:GetPowerCapacity()
    local powerGeneration = ent:GetPowerGeneration()

    self:TransmitPowerToNearbyEntities(ent)

    if power < powerCapacity then
        ent:SetPower(power + powerGeneration)
    else
        ent:SetPower(powerCapacity)
    end

    if power > powerCapacity then
        ent:SetPower(powerCapacity)
    end

end

local generatorModuleInstance = BW_GENERATOR_MODULE.New()
BaseWars.Entity.Modules:Add(generatorModuleInstance)