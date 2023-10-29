DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Money printer"
ENT.Model   = "models/props_lab/reciever01a.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsPrinter = true
ENT.UsePower = true

ENT.Modules = {
    [0] = "Printer",
    [1] = "Upgradeable",
    [2] = "Power"
}

ENT.BaseCapacity = 1000
ENT.BasePrintRate = 10
ENT.BasePrintCoolDown = 1

ENT.LastTimePrinted = 0

ENT.PowerUsage = 10
ENT.PowerCapacity = 100

local UpgradeModule = nil
local PrinterModule = nil

function ENT:Init()
    if CLIENT then return end

    UpgradeModule = BaseWars.Entity.Modules:Get("Upgradeable")
    PrinterModule = BaseWars.Entity.Modules:Get("Printer")

    self:SetMoney(0)
    self:SetCapacity(1000)
    self:SetPrintRate(100)
    self:SetPrintCoolDown(1)
    self:SetUpgradeLevel(1)

    self:SetPowerUsage(10)
    self:SetPowerCapacity(100)

    self:Upgrade()
end

function ENT:Think()
    if CLIENT then return end

    self:RunModules("OnThink")

    print("Money: " .. self:GetMoney(), "Power: " .. self:GetPower())
end

if SERVER then 

    function ENT:Upgrade()
        UpgradeModule.Upgrade(self)

        local upgradeLevel = self:GetUpgradeLevel()

        self:SetCapacity(self.BaseCapacity * upgradeLevel)
        self:SetPrintRate(self.BasePrintRate * upgradeLevel)
        
    end

    function ENT:Use(ply)
        local oldMoney = self:GetMoney()

        if PrinterModule.Use(self, ply) then
            BaseWars.Notify.Send(ply, "You have collected", "$" .. oldMoney .. " from the printer", Color(0, 255, 0))
        end
    end

end




