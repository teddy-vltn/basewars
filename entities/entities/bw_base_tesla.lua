DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Tesla"

ENT.Model           = "models/props_c17/FurnitureBoiler001a.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsTurret = true

ENT.Modules = {
    [0] = "Tesla",
    [1] = "Power"
}

ENT.BaseDamage = 1
ENT.BaseFireRate = 0.16

ENT.PowerUsage = 10
ENT.PowerCapacity = 100

ENT.LastTimeFired = 0

ENT.Radius = 300

local TeslaModule = nil
local PowerModule = nil

function ENT:LoadConfig()
    local teslaConfig = BaseWars.Config.Entities.Teslas[self:GetClass()]

    if not teslaConfig then
        print("Error: Tesla configuration not found for ", self:GetClass())
        return
    end

    self.BaseDamage = teslaConfig.BaseDamage or self.BaseDamage
    self.BaseFireRate = teslaConfig.BaseFireRate or self.BaseFireRate
    self.PowerUsage = teslaConfig.PowerUsage or self.PowerUsage
    self.PowerCapacity = teslaConfig.PowerCapacity or self.PowerCapacity
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    TeslaModule = BaseWars.Entity.Modules:Get("Tesla")
    PowerModule = BaseWars.Entity.Modules:Get("Power")

    self:SetDamage(self.BaseDamage)
    self:SetFireRate(self.BaseFireRate)

    self:SetPower(0)
    self:SetPowerUsage(self.PowerUsage)
    self:SetPowerCapacity(self.PowerCapacity)
end

function ENT:Think()
    if CLIENT then return end

    TeslaModule:OnThink(self)
    PowerModule:OnThink(self)

end