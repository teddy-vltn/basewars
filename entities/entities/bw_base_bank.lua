DEFINE_BASECLASS("bw_base")

AddCSLuaFile()

ENT.PrintName       = "Bank"
ENT.Model   = "models/props_lab/reciever01a.mdl"
ENT.Spawnable       = true
ENT.AdminOnly       = true

ENT.IsBank = true

ENT.Modules = {
    [0] = "Bank",
    [1] = "Power",
    [2] = "Value"
}

/*
        {"BankRate", 0, "Int"},
        {"BankCoolDown", 0, "Int"},
        {"BankAmount", 0, "Int"},
        {"BankRadius", 0, "Int"},
        {"BankCapacity", 0, "Int"}
*/

ENT.BaseBankCapacity = 1000
ENT.BaseBankRate = 100
ENT.BaseBankCoolDown = 1
ENT.BaseBankAmount = 10000
ENT.BaseBankRadius = 100

ENT.PowerUsage = 10
ENT.PowerCapacity = 100

ENT.BankColor = Color(0, 0, 0)

local BankModule = nil
local PowerModule = nil

function ENT:LoadConfig()
    local bankConfig --= BaseWars.Config.Entities.Banks[self:GetClass()]

    if not bankConfig then
        print("Error: Bank configuration not found for ", self:GetClass())
        return
    end

    self.BaseBankCapacity = bankConfig.BaseBankCapacity
    self.BaseBankRate = bankConfig.BaseBankRate
    self.BaseBankCoolDown = bankConfig.BaseBankCoolDown
    self.BaseBankAmount = bankConfig.BaseBankAmount
    self.BaseBankRadius = bankConfig.BaseBankRadius
    self.BankColor = bankConfig.BankColor   
end

function ENT:Init()
    if CLIENT then return end

    self:LoadConfig()

    self:SetColor(self.BankColor)

    BankModule = BaseWars.Entity.Modules:Get("Bank")
    PowerModule = BaseWars.Entity.Modules:Get("Power")

    self:SetBankCapacity(self.BaseBankCapacity)
    self:SetBankRate(self.BaseBankRate)
    self:SetBankCoolDown(self.BaseBankCoolDown)
    self:SetBankAmount(self.BaseBankAmount)
    self:SetBankRadius(self.BaseBankRadius)

    self:SetPowerUsage(self.PowerUsage)
    self:SetPowerCapacity(self.PowerCapacity)
end

function ENT:Think()
    if CLIENT then return end

    local isPowered = PowerModule:OnThink(self)

    if not isPowered then return end

    BankModule:Think(self)

    BankModule:Bank(self)
end






