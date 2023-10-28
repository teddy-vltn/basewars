DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Money printer"
ENT.Model   = "models/props_lab/reciever01a.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsPrinter = true

ENT.Modules = {
    [0] = "Printer",
    [1] = "Upgradeable"
}

ENT.BaseCapacity = 1000
ENT.BasePrintRate = 10
ENT.BasePrintCoolDown = 1

ENT.LastTimePrinted = 0

function ENT:Init()
    if CLIENT then return end

    self:SetMoney(0)
    self:SetCapacity(1000)
    self:SetPrintRate(100)
    self:SetPrintCoolDown(1)
    self:SetUpgradeLevel(1)
end

function ENT:Think()
    if CLIENT then return end

    self:RunModules("OnThink")
end




