DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Reasearch Base"

ENT.Model           = "models/props_wasteland/laundry_washer003.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsResearch = true

ENT.Modules = {
    [0] = "Research"
}

local ResearchModule = nil

if SERVER then
    function ENT:Init()
        ResearchModule = BaseWars.Entity.Modules:Get("Research")
    end
    
    function ENT:Think()
        ResearchModule:OnThink(self)
    end
    
    function ENT:Use(ply)
        ResearchModule:Use(self, ply)
    end
else 
    function ENT:Draw()
        self:DrawModel()
    end
end



