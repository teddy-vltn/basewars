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

ENT.PrinterColor = Color(0, 0, 0)

local UpgradeModule = nil
local PrinterModule = nil
local PowerModule = nil

function ENT:LoadConfig()
    local printerConfig = BaseWars.Config.Printers[self:GetClass()]

    if not printerConfig then
        print("Error: Printer configuration not found for ", self:GetClass())
        return
    end

    self.BaseCapacity = printerConfig.BaseCapacity
    self.BasePrintRate = printerConfig.BasePrintRate
    self.BasePrintCoolDown = printerConfig.BasePrintCoolDown
    self.PowerUsage = printerConfig.PowerUsage
    self.PowerCapacity = printerConfig.PowerCapacity
    self.PrinterColor = printerConfig.PrinterColor
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    self:SetColor(self.PrinterColor)

    UpgradeModule = BaseWars.Entity.Modules:Get("Upgradeable")
    PrinterModule = BaseWars.Entity.Modules:Get("Printer")
    PowerModule = BaseWars.Entity.Modules:Get("Power")

    self:SetMoney(0)
    self:SetCapacity(self.BaseCapacity)
    self:SetPrintRate(self.BasePrintRate)
    self:SetPrintCoolDown(self.BasePrintCoolDown)
    self:SetUpgradeLevel(1)

    self:SetPowerUsage(self.PowerUsage)
    self:SetPowerCapacity(self.PowerCapacity)

    self:Upgrade()
end

function ENT:Think()
    if CLIENT then return end

    PrinterModule:OnThink(self)
    PowerModule:OnThink(self)

    print("Money: " .. self:GetMoney(), "Power: " .. self:GetPower())
end

if SERVER then 

    function ENT:Upgrade()
        UpgradeModule:Upgrade(self)

        local upgradeLevel = self:GetUpgradeLevel()

        self:SetCapacity(self.BaseCapacity * upgradeLevel)
        self:SetPrintRate(self.BasePrintRate * upgradeLevel)
        
    end

    function ENT:Use(ply)
        local oldMoney = self:GetMoney()

        if PrinterModule:Use(self, ply) then
            BaseWars.Notify.Send(ply, "You have collected", "$" .. oldMoney .. " from the printer", Color(0, 255, 0))
        end
    end

end




