DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Power Generator"

ENT.Model           = "models/props_wasteland/laundry_washer003.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsGenerator = true

ENT.Modules = {
    [0] = "Generator"
}

ENT.BasePowerGeneration = 100
ENT.BasePowerCapacity = 1000

local GeneratorModule = nil

function ENT:LoadConfig()
    local generatorConfig = BaseWars.Config.Entities.Generators[self:GetClass()]

    if not generatorConfig then
        print("Error: Generator configuration not found for ", self:GetClass())
        return
    end

    self.BasePowerGeneration = generatorConfig.BasePowerGeneration
    self.BasePowerCapacity = generatorConfig.BasePowerCapacity
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    GeneratorModule = BaseWars.Entity.Modules:Get("Generator")

    self:SetPowerGeneration(self.BasePowerGeneration)
    self:SetPowerCapacity(self.BasePowerCapacity)
    self:SetPower(0)
end

function ENT:Think()
    if CLIENT then return end

    GeneratorModule:OnThink(self)

    print("Power: " .. self:GetPower())
end