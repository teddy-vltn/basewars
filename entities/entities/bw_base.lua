DEFINE_BASECLASS("base_anim")

AddCSLuaFile()

ENT.PrintName       = "Base Entity"
ENT.Author          = "OpenAI"
ENT.Information     = "The base entity for all BaseWars entities"
ENT.Category        = "BaseWars"
ENT.Editable        = false
ENT.Spawnable       = false
ENT.AdminOnly       = false
ENT.RenderGroup     = RENDERGROUP_OPAQUE

ENT.Model           = "models/props_lab/reciever01a.mdl"
ENT.Skin            = 0

ENT.PresetMaxHealth = 100

-- Modules list
ENT.Modules         = {}
ENT.AllNetworkVars  = {}

ENT.IsBaseWarsEntity = true

function ENT:Init()
        -- Run module initializations

end

function ENT:SetupDataTables()
    print("Setting up data tables")

    local i = 0

    for _, nwVar in ipairs(self.AllNetworkVars) do
        i = i + 1
        local varType, slot, name = unpack(nwVar)
        self:NetworkVar(name, slot + i, varType)
        print("Added network var: " .. name)
    end
end

function ENT:Initialize()

    self:SetHealth(100)

    self:SetModel(self.Model)
    self:SetSkin(self.Skin)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)

    self:AddEffects(EF_ITEM_BLINK)
    
    self:SetHealth(self.PresetMaxHealth)

    self:SetupDataTables()

    self:Init()

    self:PhysWake()
    self:Activate()

    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

end

function ENT:OnTakeDamage(dmg)
    local newHealth = self:Health() - dmg:GetDamage()
    self:SetHealth(newHealth)

    if newHealth <= 0 then
        self:OnDeath(dmg)
    end

    for _, module in ipairs(self.Modules) do
        if module.OnTakeDamage then
            module.OnTakeDamage(self, dmg)
        end
    end
end

function ENT:OnDeath(dmg)
    for _, module in ipairs(self.Modules) do
        if module.OnDeath then
            module.OnDeath(self, dmg)
        end
    end
end

function ENT:InitializeModules()
    for i = 0, #self.Modules do

        local moduleName = self.Modules[i] or ""
        
        local moduleManager = BaseWars.Entity.Modules
        local module = moduleManager:Get(moduleName)

        if !module then
            print("Module " .. moduleName .. " does not exist!")
            continue
        end

        self:AddModule(module)
    end
end

function ENT:AddModule(module)

    table.insert(self.Modules, module)

    if module.NetworkVars then
        for _, nwVar in ipairs(module.NetworkVars) do
            table.insert(self.AllNetworkVars, nwVar)
        end
    end

end

function ENT:RunModules(func)
    for _, module in ipairs(self.Modules) do
        if module[func] then
            module[func](self) 
        end
    end
end