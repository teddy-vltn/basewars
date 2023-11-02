local BW_DISPENSER_MODULE = {}
BW_DISPENSER_MODULE.__index = BW_DISPENSER_MODULE

-- Constants
local MODULE_NAME = "Dispenser"
local MODULE_DESC = "Allows you to dispense any kind of data"

-- Initialization
function BW_DISPENSER_MODULE.New()
    local self = setmetatable({}, BW_DISPENSER_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"DispenseRate", 0, "Int"},
        {"DispenseCoolDown", 0, "Int"},
        {"DispenseAmount", 0, "Int"},
        {"DispenseCapacity", 0, "Int"},
        {"DispenseType", 0, "String"},
        {"Sound", 0, "String"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_DISPENSER_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized

    print("Dispenser module initialized for entity: ", ent)
end

function BW_DISPENSER_MODULE:Dispense(ent, ply)
    local DispenseType = ent:GetDispenseType()
    local DispenseAmount = ent:GetDispenseAmount()

    -- Define dispensing logic based on the type
    if DispenseType == "Ammo" then
        -- Dispense ammo logic
        local PlyGun = ply:GetActiveWeapon()
        if IsValid(PlyGun) and PlyGun:GetPrimaryAmmoType() then
            local AmmoType = PlyGun:GetPrimaryAmmoType()
            ply:GiveAmmo(DispenseAmount, AmmoType)
        end

        ent:SetDispenseAmount(0)

    elseif DispenseType == "Health" then
        -- Dispense health logic and remove only what the player needs
        local needed = ply:GetMaxHealth() - ply:Health()
        local newHealth = math.min(ply:GetMaxHealth(), ply:Health() + DispenseAmount)

        ply:SetHealth(newHealth)

        ent:SetDispenseAmount(DispenseAmount - needed)
    elseif DispenseType == "Armor" then
        -- Dispense armor logic
        local needed = 100 - ply:Armor()
        local newArmor = math.min(100, ply:Armor() + DispenseAmount)

        ply:SetArmor(newArmor)

        ent:SetDispenseAmount(DispenseAmount - needed)
    else
        print("Unknown DispenseType:", DispenseType)
    end

end


function BW_DISPENSER_MODULE:OnThink(ent)
    if CLIENT then return end

    -- Check if the entity was initialized with this module
    if not self.InitializedEntities[ent] then return end

    local DispenseRate = ent:GetDispenseRate()
    local DispenseCoolDown = ent:GetDispenseCoolDown()
    local DispenseType = ent:GetDispenseType()
    local DispenseAmount = ent:GetDispenseAmount()
    local DispenseCapacity = ent:GetDispenseCapacity()
    local LastTimeDispensed = ent.LastTimeDispensed or 0

    if DispenseCapacity > 0 and DispenseAmount >= DispenseCapacity then return end

    if CurTime() - LastTimeDispensed >= DispenseCoolDown then
        
        ent:SetDispenseAmount(math.min(DispenseAmount + DispenseRate, DispenseCapacity))

        ent.LastTimeDispensed = CurTime()
    end

    return true
end

function BW_DISPENSER_MODULE:OnUse(ent, ply)
    if not ply:IsPlayer() then return end

    -- Check if the entity was initialized with this module
    if not self.InitializedEntities[ent] then return end

    self:Dispense(ent, ply)
end

local dispenserModuleInstance = BW_DISPENSER_MODULE.New()
BaseWars.Entity.Modules:Add(dispenserModuleInstance)

