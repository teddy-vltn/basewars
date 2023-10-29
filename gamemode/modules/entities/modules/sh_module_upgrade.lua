local BW_UPGRADE_MODULE = {}
BW_UPGRADE_MODULE.__index = BW_UPGRADE_MODULE

-- Constants
local MODULE_NAME = "Upgradeable"
local MODULE_DESC = "Allows you to upgrade your entity"

-- Initialization
function BW_UPGRADE_MODULE.New()
    local self = setmetatable({}, BW_UPGRADE_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"UpgradeLevel", 0, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_UPGRADE_MODULE.Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized
    print("Upgrade module initialized")
end

function BW_UPGRADE_MODULE.Upgrade(ent)
    ent:SetUpgradeLevel(ent:GetUpgradeLevel() + 1)
end

local upgradeModuleInstance = BW_UPGRADE_MODULE.New()
BaseWars.Entity.Modules:Add(upgradeModuleInstance)