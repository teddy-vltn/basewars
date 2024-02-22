DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "SpawnPoint"

ENT.Model           = "models/props_trainstation/trainstation_clock001.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.Modules = {
    [0] = "SpawnPoint",
    [1] = "Power",
    [2] = "Value"
}

local SpawnPointModule = nil
local PowerModule = nil

ENT.PowerUsage = 10
ENT.PowerCapacity = 100

function ENT:LoadConfig()
    local spawnPointConfig = BaseWars.Config.Entities.SpawnPoints[self:GetClass()]

    if not spawnPointConfig then
        print("Error: SpawnPoint configuration not found for ", self:GetClass())
        return
    end

    self.PowerUsage = spawnPointConfig.PowerUsage
    self.PowerCapacity = spawnPointConfig.PowerCapacity
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    SpawnPointModule = BaseWars.Entity.Modules:Get("SpawnPoint")
    PowerModule = BaseWars.Entity.Modules:Get("Power")

    self:SetPower(0)
    self:SetPowerUsage(self.PowerUsage)
    self:SetPowerCapacity(self.PowerCapacity)
end

function ENT:Think()
    if CLIENT then return end

    PowerModule:OnThink(self)

end

if SERVER then

    function ENT:Use(ply)
        local status, message = SpawnPointModule:UseFunc(self, ply)

        BaseWars.Notify.Send(ply, "Activer le spawnpoint", message, status and Color(0, 255, 0) or Color(255, 0, 0))
    end

end