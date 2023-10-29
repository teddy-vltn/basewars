local BW_POWER_MODULE = {}
BW_POWER_MODULE.__index = BW_POWER_MODULE

-- Constants
local MODULE_NAME = "Power"
local MODULE_DESC = "Allows you to generate electricity"

-- Initialization
function BW_POWER_MODULE.New()
    local self = setmetatable({}, BW_POWER_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"PowerUsage", 0, "Int"},
        {"PowerCapacity", 0, "Int"},
        {"Power", 0, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_POWER_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized

    print("Power module initialized")
end

function BW_POWER_MODULE:OnThink(ent)
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

function BW_POWER_MODULE:ReceivePower(ent, power)
    local actualPower = ent:GetPower()
    local powerCapacity = ent:GetPowerCapacity()

    if actualPower + power > powerCapacity then
        ent:SetPower(powerCapacity)
    else
        ent:SetPower(actualPower + power)
    end
end

function BW_POWER_MODULE:DrainPower(ent, power)
    local power = ent:GetPower()

    if power - power < 0 then
        ent:SetPower(0)
    else
        ent:SetPower(power - power)
    end
end

local powerModuleInstance = BW_POWER_MODULE.New()
BaseWars.Entity.Modules:Add(powerModuleInstance)