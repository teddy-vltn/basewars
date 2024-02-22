local BW_BANK_MODULE = {}
BW_BANK_MODULE.__index = BW_BANK_MODULE

-- Constants
local MODULE_NAME = "Bank"
local MODULE_DESC = "Allows the entity to grab money from nearby printers"

-- Initialization
function BW_BANK_MODULE.New()
    local self = setmetatable({}, BW_BANK_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"BankRate", 0, "Int"},
        {"BankCoolDown", 0, "Int"},
        {"BankAmount", 0, "Int"},
        {"BankRadius", 0, "Int"},
        {"BankCapacity", 0, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_BANK_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized

    print("Bank module initialized for entity: ", ent)
end

function BW_BANK_MODULE:Bank(ent)
    local BankRate = ent:GetBankRate()
    local BankCoolDown = ent:GetBankCoolDown()
    local BankAmount = ent:GetBankAmount()
    local BankRadius = ent:GetBankRadius()

    -- Define banking logic
    local pos = ent:GetPos()
    local nearbyPrinters = ents.FindInSphere(pos, BankRadius)
    local totalBanked = 0

    for _, printer in pairs(nearbyPrinters) do

        if printer.IsPrinter then
            local money = printer:GetMoney()

            if money > 0 then
                local toBank = math.min(money, BankRate)

                printer:SetMoney(money - toBank)
                totalBanked = totalBanked + toBank
            end
        end
    end

    ent:SetBankAmount(totalBanked + ent:GetBankAmount())

    print("Banked: ", totalBanked)
end

function BW_BANK_MODULE:Think(ent)
    if not self.InitializedEntities[ent] then return end

    local BankCoolDown = ent:GetBankCoolDown()

    if BankCoolDown > 0 then
        ent:SetBankCoolDown(BankCoolDown - 1)
    end
end

local bankModule = BW_BANK_MODULE.New()
BaseWars.Entity.Modules:Add( bankModule )