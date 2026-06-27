local BW_VALUE_MODULE = {}
BW_VALUE_MODULE.__index = BW_VALUE_MODULE

local MODULE_NAME = "Value"
local MODULE_DESC = "Allows you to set a value for your entity"

function BW_VALUE_MODULE.New()
    local self = setmetatable({}, BW_VALUE_MODULE)

    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"Value", 0, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {}

    return self
end

function BW_VALUE_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true
    print("Value module initialized")
end

function BW_VALUE_MODULE:SetValue(ent, value)
    ent:SetValue(value)
end

local valueModuleInstance = BW_VALUE_MODULE.New()
BaseWars.Entity.Modules:Add(valueModuleInstance)

PrintTable(BaseWars.Entity.Modules)