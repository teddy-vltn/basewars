DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Turret"

ENT.Model           = "models/combine_turrets/floor_turret.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsTurret = true

ENT.Modules = {
    [0] = "Turret",
    [1] = "Power",
    [2] = "Value"
}

ENT.BaseDamage = 10
ENT.BaseFireRate = 0.16

ENT.PowerUsage = 10
ENT.PowerCapacity = 100

ENT.LastTimeFired = 0

ENT.Radius = 1000

ENT.FOV = 100

local TurretModule = nil
local PowerModule = nil

function ENT:LoadConfig()
    local turretConfig = BaseWars.Config.Entities.Turrets[self:GetClass()]

    if not turretConfig then
        print("Error: Turret configuration not found for ", self:GetClass())
        return
    end

    self.BaseDamage = turretConfig.BaseDamage or self.BaseDamage
    self.BaseFireRate = turretConfig.BaseFireRate or self.BaseFireRate
    self.PowerUsage = turretConfig.PowerUsage or self.PowerUsage
    self.PowerCapacity = turretConfig.PowerCapacity or self.PowerCapacity
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    TurretModule = BaseWars.Entity.Modules:Get("Turret")
    PowerModule = BaseWars.Entity.Modules:Get("Power")

    self:SetDamage(self.BaseDamage)
    self:SetFireRate(self.BaseFireRate)

    self:SetPower(0)
    self:SetPowerUsage(self.PowerUsage)
    self:SetPowerCapacity(self.PowerCapacity)
end

function ENT:Think()
    if CLIENT then return end
    
    local isPowered = PowerModule:OnThink(self)

    if not isPowered then return end

    TurretModule:OnThink(self)
end