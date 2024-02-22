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
    [2] = "Power",
    [3] = "Value"
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
    local printerConfig = BaseWars.Config.Entities.Printers[self:GetClass()]

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
end

if SERVER then 

    function ENT:Upgrade()
        UpgradeModule:Upgrade(self)

        local upgradeLevel = self:GetUpgradeLevel()

        self:SetCapacity(self.BaseCapacity * upgradeLevel)
        self:SetPrintRate(self.BasePrintRate * upgradeLevel)

        self:SetValue(upgradeLevel)
        
    end

    function ENT:Use(ply)
        local oldMoney = self:GetMoney()

        if PrinterModule:Use(self, ply) then
            BaseWars.Notify.Send(ply, "You have collected", "$" .. oldMoney .. " from the printer", Color(0, 255, 0))
        end
    end

else 

    local fontName = "BaseWars.MoneyPrinter"

    surface.CreateFont(fontName, {
        font = "Roboto",
        size = 24,
        weight = 1000
    })

    surface.CreateFont(fontName .. ".Big", {
        font = "Roboto",
        size = 32,
        weight = 1000
    })

    surface.CreateFont(fontName .. ".MedBig", {
        font = "Roboto",
        size = 28,
        weight = 1000
    })

    

    function ENT:DrawDisplay(pos, ang, scale)
        local w, h = 216 * 2, 136 * 2
    
        -- Background
        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))

        -- Afficher le nom de l'imprimante
        draw.DrawText(self.PrintName, fontName, w / 2, 4, Color(255, 255, 255), TEXT_ALIGN_CENTER)

        -- Afficher le niveau
        --draw.DrawText("LEVEL: " .. self:GetLevel(), fontName .. ".Big", 4, 32, self.FontColor, TEXT_ALIGN_LEFT)
        --surface.DrawLine(0, 68, w, 68)

        -- Afficher l'argent actuellement dans l'imprimante
        local currentMoney = BaseWars.NumberFormat(self:GetMoney())
        local maxMoney = BaseWars.NumberFormat(self:GetCapacity())
        draw.DrawText("CASH: " .. currentMoney .. " / " .. maxMoney, fontName .. ".Big", 4, 72, Color(255, 255, 255), TEXT_ALIGN_LEFT)

        -- Afficher le papier restant
       --local paper = math.floor(self:GetPaper())
        --draw.DrawText("Paper: " .. paper .. " sheets", fontName .. ".MedBig", 4, 94 + 49, self.FontColor, TEXT_ALIGN_LEFT)
    end

    function ENT:Calc3D2DParams()
        local pos = self:GetPos()
        local ang = self:GetAngles()

        pos = pos + ang:Up() * 3.09
        pos = pos + ang:Forward() * -7.35
        pos = pos + ang:Right() * 10.82

        ang:RotateAroundAxis(ang:Up(), 90)

        return pos, ang, 0.1 / 2
    end
end
    
function ENT:Draw()
    self:DrawModel()

    if CLIENT then
        local pos, ang, scale = self:Calc3D2DParams()

        cam.Start3D2D(pos, ang, scale)
            pcall(self.DrawDisplay, self, pos, ang, scale)
        cam.End3D2D()
    end
end


    




