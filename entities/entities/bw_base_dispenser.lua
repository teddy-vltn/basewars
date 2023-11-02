DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Dispenser"

ENT.Model           = "models/props_lab/reciever01a.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsDispenser = true

ENT.Modules = {
    [0] = "Dispenser", 
    [1] = "Power"
}

ENT.BaseDispenseRate = 1
ENT.BaseDispenseCoolDown = 1
ENT.BaseDispenseCapacity = 100

ENT.DispenseType = "Health"

ENT.LastTimeDispensed = 0

ENT.Sound = "ambient/water/drip2.wav"

local DispenserModule = nil

function ENT:LoadConfig()
    local dispenserConfig = BaseWars.Config.Entities.Dispensers[self:GetClass()]

    if not dispenserConfig then
        print("Error: Dispenser configuration not found for ", self:GetClass())
        return
    end

    self.BaseDispenseRate = dispenserConfig.BaseDispenseRate
    self.BaseDispenseCoolDown = dispenserConfig.BaseDispenseCoolDown
    self.BaseDispenseCapacity = dispenserConfig.BaseDispenseCapacity
    self.DispenseType = dispenserConfig.DispenseType
    self.Sound = dispenserConfig.Sound
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    DispenserModule = BaseWars.Entity.Modules:Get("Dispenser")

    self:SetDispenseRate(self.BaseDispenseRate)
    self:SetDispenseCoolDown(self.BaseDispenseCoolDown)
    self:SetDispenseCapacity(self.BaseDispenseCapacity)
    self:SetDispenseType(self.DispenseType)
    self:SetSound(self.Sound)
end

function ENT:Think()
    if CLIENT then return end

    DispenserModule:OnThink(self)
end

if SERVER then

    function ENT:Use(activator, caller)
        if not activator:IsPlayer() then return end

        DispenserModule:OnUse(self, activator)
    end

end

