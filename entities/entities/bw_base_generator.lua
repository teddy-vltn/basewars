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

function ENT:Init()
    if CLIENT then return end

    GeneratorModule = BaseWars.Entity.Modules:Get("Generator")

    self:SetPowerGeneration(self.BasePowerGeneration)
    self:SetPowerCapacity(self.BasePowerCapacity)
    self:SetPower(0)
end

function ENT:Think()
    if CLIENT then return end

    self:RunModules("OnThink")

    print("Power: " .. self:GetPower())
end