BaseWars.ConVar = BaseWars.ConVar or {}
BaseWars.ConVar.Cache = BaseWars.ConVar.Cache or {}

function BaseWars.ConVar.Register(var, name, default, helpText)
    local convar = CreateClientConVar(var, default, true, false, helpText)

    BaseWars.ConVar.Cache[var] = {
        var = var,
        convar = convar,
        name = name,
        default = default,
        description = helpText,
    }
end

function BaseWars.ConVar.CreateConVarHandler(convarName, isBool)
    local handler = {
        convarName = convarName,
        value = nil, -- Will be set in Refresh()
        keycode = nil, -- Relevant only for key convars
    }

    print(handler.convarName, isBool)

    function handler:Refresh()
        local rawValue = BaseWars.ConVar.Get(self.convarName)
        
        if isBool then
            self.value = rawValue == "1"
        else
            self.value = rawValue
            self.keycode = input.GetKeyCode(rawValue)
        end
    end

    -- Automatically refresh when the convar changes
    cvars.AddChangeCallback(convarName, function(name, old, new)
        handler:Refresh()
    end)

    -- Initialize
    handler:Refresh()

    return handler
end

function BaseWars.ConVar.Get(name)
    local conVarData = BaseWars.ConVar.Cache[name]
    if not conVarData then
        error("ConVar '" .. name .. "' not found. Make sure it is registered before accessing it.")
    end
    -- Assuming `conVarData.convar` is a ConVar object, and `GetString` is a valid method.
    return conVarData.convar:GetString():upper() or conVarData.default
end

function BaseWars.ConVar.Set(name, value)
    BaseWars.ConVar.Cache[name].convar:SetString(value)
end

function BaseWars.ConVar.Reset(name)
    BaseWars.ConVar.Cache[name].convar:SetString(BaseWars.ConVar.Cache[name].default)
end

function BaseWars.ConVar.GetDefault(name)
    return BaseWars.ConVar.Cache[name].default
end

function BaseWars.ConVar.GetDescription(name)
    return BaseWars.ConVar.Cache[name].description
end

function BaseWars.ConVar.GetVar(name)
    return BaseWars.ConVar.Cache[name].var
end

-- Register the convars

-- Menu Open Key
BaseWars.ConVar.Register("basewars_menu_key", "BaseWars Menu Key", "F4", "The key to open the BaseWars menu")
-- Always Focus Menu
BaseWars.ConVar.Register("basewars_menu_focus", "BaseWars Menu Focus", "0", "Whether the menu should always focus on open")


BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.MenuOpenKey = BaseWars.ConVar.CreateConVarHandler("basewars_menu_key", false)
BaseWars.Config.MenuAlwaysFocus = BaseWars.ConVar.CreateConVarHandler("basewars_menu_focus", true)

