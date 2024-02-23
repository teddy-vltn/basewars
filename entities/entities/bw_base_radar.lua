DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Radar"
ENT.Model   = "models/props_wasteland/controlroom_filecabinet002a.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsRadar = true

ENT.Modules = {
    [0] = "Radar",
    [1] = "Power",
    [2] = "Value"
}

/*
        self.NetworkVars = {
        {"RadarCoolDown", 0, "Int"},
        {"RadarRadius", 0, "Int"},
    }
*/

ENT.BaseRadarRadius = 10000
ENT.BaseRadarCoolDown = 5

ENT.PowerUsage = 10
ENT.PowerCapacity = 100

local RadarModule = nil
local PowerModule = nil

function ENT:LoadConfig()
    local radarConfig = BaseWars.Config.Entities.Radars[self:GetClass()]

    if not radarConfig then
        print("Error: Radar configuration not found for ", self:GetClass())
        return
    end

    self.BaseRadarRadius = radarConfig.BaseRadarRadius
    self.BaseRadarCoolDown = radarConfig.BaseRadarCoolDown
end

function ENT:Init()
    if CLIENT then return end

    --self:LoadConfig()

    RadarModule = BaseWars.Entity.Modules:Get("Radar")
    PowerModule = BaseWars.Entity.Modules:Get("Power")

    self:SetRadarRadius(self.BaseRadarRadius)
    self:SetRadarCoolDown(self.BaseRadarCoolDown)
end

if SERVER then
    function ENT:Use(ply)
        if not IsValid(ply) then return end

        RadarModule:Use(self, ply)
    end
end
