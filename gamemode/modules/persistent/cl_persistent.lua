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

function BaseWars.ConVar.CreateConVarHandler(convarName, isBool, callback)
    local handler = {
        convarName = convarName,
        value = nil, -- Will be set in Refresh()
        keycode = nil, -- Relevant only for key convars
    }

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

        if callback then
            callback(handler.value)
        end
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
BaseWars.ConVar.Register("basewars_menu_focus", "BaseWars Menu Focus", "0", "Whether the menu should always focus on open. If enabled the menu will rebuild everytime not saving the previous state. If disabled the menu will save the previous state and rebuild only when needed.")
-- Open default sandbox menu (only in debug mode)
BaseWars.ConVar.Register("basewars_debug_open_sandbox_menu", "Open Sandbox Menu", "0", "Can the default sandbox menu be opened? (Only in debug mode)")
-- BaseWars FPS Boost
BaseWars.ConVar.Register("basewars_fps_boost", "Tryhard mode (~FPS Boost)", "0", "Enable or disable the BaseWars FPS Boost. This will disable some features to increase FPS.")

BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.MenuOpenKey = BaseWars.ConVar.CreateConVarHandler("basewars_menu_key", false)
BaseWars.Config.MenuAlwaysFocus = BaseWars.ConVar.CreateConVarHandler("basewars_menu_focus", true)
BaseWars.Config.DebugOpenSandboxMenu = BaseWars.ConVar.CreateConVarHandler("basewars_debug_open_sandbox_menu", true)

local consoleCommands = {}
local function addConsoleCommand(name, boostValue)
    consoleCommands[name] = {
        boostValue = boostValue,
        playerValue = GetConVar(name):GetString(),
    }
end

addConsoleCommand("r_3dsky", "0")
addConsoleCommand("r_shadows", "0")
addConsoleCommand("r_shadowmaxrendered", "0")
addConsoleCommand("r_shadowrendertotexture", "0")
addConsoleCommand("r_shadowfromworldlights", "0")
addConsoleCommand("r_maxmodeldecal", "0")
addConsoleCommand("mat_dxlevel", "70")
addConsoleCommand("mat_bumpmap", "0")
addConsoleCommand("mat_specular", "1")
addConsoleCommand("mat_picmip", "4")
addConsoleCommand("mat_queue_mode", "2")
addConsoleCommand("cl_detaildist", "0")
addConsoleCommand("gmod_mcore_test", "1")

-- "FPS Boost" ConVar
BaseWars.Config.FPSBoost = BaseWars.ConVar.CreateConVarHandler("basewars_fps_boost", true, function(value)
    if value then -- Enable
        for name, data in pairs(consoleCommands) do
            RunConsoleCommand(name, data.boostValue)
        end
    else -- Disable
        for name, data in pairs(consoleCommands) do
            RunConsoleCommand(name, data.playerValue)
        end
    end
end)
