BaseWars = BaseWars or {}
BaseWars.Modules = BaseWars.Modules or {}
BaseWars.ModulesOrder = BaseWars.ModulesOrder or {}
BaseWars.LoadedModules = {}

-- Registers a module with optional dependencies
function BaseWars.RegisterModule(name, dependencies, path, prefix)
    if not BaseWars.Modules[name] then
        BaseWars.ModulesOrder[#BaseWars.ModulesOrder + 1] = name
    end
    BaseWars.Modules[name] = {
        name = name,
        dependencies = dependencies or {},
        path = path,
        prefix = prefix,
        loaded = false
    }

    BaseWars.Log("Registered module " .. name)
end
-- Include a module based on its type
local function IncludeModule(module)
    if SERVER then
        if module.prefix == "sv" then
            include(module.path)
        elseif module.prefix == "sh" then
            include(module.path)
            AddCSLuaFile(module.path)
        elseif module.prefix == "cl" then
            AddCSLuaFile(module.path)
        end
    elseif CLIENT then
        if module.prefix == "cl" or module.prefix == "sh" then
            include(module.path)
        end
    end
    BaseWars.LoadedModules[module.name] = true
    BaseWars.Log("Loaded module " .. module.name)
end

-- Checks if all dependencies of a module are loaded
local function DependenciesSatisfied(module)
    for _, dep in ipairs(module.dependencies) do
        if not BaseWars.LoadedModules[dep] then
            return false
        end
    end
    return true
end

-- Include all registered modules, respecting dependencies
function BaseWars.IncludeModules()
    for _, moduleName in ipairs(BaseWars.ModulesOrder) do
        local module = BaseWars.Modules[moduleName]
        if not module.loaded then
            IncludeModule(module)
            module.loaded = true
        end
    end

    BaseWars.Log("Finished loading modules")
end

function BaseWars.RegisterModuleFolder(folder, dependencies)
    dependencies = dependencies or {}

    BaseWars.Log("Registering modules in folder " .. folder)

    local files, directories = file.Find(folder .. "/*", "LUA")

    -- Separate files by type
    local svFiles = {}
    local shFiles = {}
    local clFiles = {}

    -- Classify each file by type
    for _, fileName in ipairs(files) do
        BaseWars.Log("Found file " .. fileName)
        if string.StartWith(fileName, "sv_") then
            table.insert(svFiles, fileName)
        elseif string.StartWith(fileName, "sh_") then
            table.insert(shFiles, fileName)
        elseif string.StartWith(fileName, "cl_") then
            table.insert(clFiles, fileName)
        end
    end

    -- Register shared files
    for _, fileName in ipairs(shFiles) do
        BaseWars.RegisterModule(fileName, {dependencies}, folder .. "/" .. fileName, "sh")
    end
    
    -- Register server files
    for _, fileName in ipairs(svFiles) do
        BaseWars.RegisterModule(fileName, {dependencies}, folder .. "/" .. fileName, "sv")
    end

    -- Register client files
    for _, fileName in ipairs(clFiles) do
        BaseWars.RegisterModule(fileName, {dependencies}, folder .. "/" .. fileName, "cl")
    end

    BaseWars.Log("Finished registering modules in folder " .. folder)
end

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/extras")

-- Register your modules with dependencies
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/net")
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/notify")
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/entities")
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/props")

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/persistent")

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/level")
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/money")

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/entities/modules")

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/spawnmenu")

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/faction")
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/raid")


BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/vgui/base")
BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/vgui")

BaseWars.RegisterModuleFolder(GM.FolderName .. "/gamemode/modules/hud")



-- Load all modules
BaseWars.IncludeModules()
