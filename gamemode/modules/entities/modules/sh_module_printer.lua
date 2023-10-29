local BW_PRINTER_MODULE = {}
BW_PRINTER_MODULE.__index = BW_PRINTER_MODULE

-- Constants
local MODULE_NAME = "Printer"
local MODULE_DESC = "Allows you to print money"

-- Initialization
function BW_PRINTER_MODULE.New()
    local self = setmetatable({}, BW_PRINTER_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"Money", 0, "Int"},
        {"Capacity", 0, "Int"},
        {"PrintRate", 0, "Int"},
        {"PrintCoolDown", 0, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_PRINTER_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized
    print("Printer module initialized for entity: ", ent)
end

function BW_PRINTER_MODULE:OnThink(ent)
    if CLIENT then return end

    -- Check if the entity was initialized with this module
    if not self.InitializedEntities[ent] then return end

    local money = ent:GetMoney()
    local capacity = ent:GetCapacity()
    local printRate = ent:GetPrintRate()
    local LastTimePrinted = ent.LastTimePrinted or 0
    local PrintCoolDown = ent:GetPrintCoolDown()

    if money < capacity and CurTime() - LastTimePrinted >= PrintCoolDown then
        ent:SetMoney(money + printRate)
        ent.LastTimePrinted = CurTime()
    end
end

function BW_PRINTER_MODULE:Use(ent, ply)
    if not ply:IsPlayer() then return end

    -- Check if the entity was initialized with this module
    if not self.InitializedEntities[ent] then return end

    local money = ent:GetMoney()
    if money > 0 then
        ply:AddMoney(money)
        ent:SetMoney(0)
    else
        return false
    end
    return true
end

local printerModuleInstance = BW_PRINTER_MODULE.New()
BaseWars.Entity.Modules:Add(printerModuleInstance)
