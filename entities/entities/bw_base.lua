DEFINE_BASECLASS("base_anim")

AddCSLuaFile()

ENT.PrintName       = "Base Entity"
ENT.Author          = "Teddy"
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

ENT.InitializedModules = {}

function ENT:Init()
    print("Initialized base entity")
end

function ENT:CanSell()
    return self.GetValue and self:GetValue() > 0
end

function ENT:CanUpgrade()
    return self.GetUpgradeLevel and self:GetUpgradeLevel() >= 0
end

function ENT:IsBaseWars()
    return true
end

function ENT:SetupDataTables()
    print("Setting up data tables")

    -- Initialiser les modules ici (avant de définir les NetworkVars)
    self:InitializeModules()

    local i = 0
    /*for _, nwVar in ipairs(self.AllNetworkVars) do
        i = i + 1
        local varType, slot, name = unpack(nwVar)
        self:NetworkVar(name, slot + i, varType)
        print("Added network var: " .. name)
    end*/

    local i = {
        ["Int"] = 0,
        ["Float"] = 0,
        ["String"] = 0,
        ["Bool"] = 0,
        ["Entity"] = 0,
        ["Vector"] = 0,
        ["Angle"] = 0,
        ["Color"] = 0
    }

    -- for initialized modules only
    for _, module in ipairs(self.InitializedModules) do
        if module.NetworkVars then
            for _, nwVar in ipairs(module.NetworkVars) do
                
                local name, slot, varType = unpack(nwVar)

                if not i[varType] then
                    print("Invalid network var type: " .. varType)
                    continue
                end

                self:NetworkVar(varType, i[varType], name)

                print("Added network var: " .. name)

                i[varType] = i[varType] + 1
            end
        end
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
    if CLIENT then return end

    local newHealth = self:Health() - dmg:GetDamage()
    self:SetHealth(newHealth)

    if newHealth <= 0 and not self.Destroyed then
        self:OnDeath(dmg)

        self.Destroyed = true

        self:Explode()
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

function ENT:Explode(e)

    if e == false then

        local vPoint = self:GetPos()
        local effectdata = EffectData()
        effectdata:SetOrigin(vPoint)
        util.Effect("Explosion", effectdata)

        self:Remove()
        
    return end

    local ex = ents.Create("env_explosion")
        ex:SetPos(self:GetPos())
    ex:Spawn()
    ex:Activate()
    
    ex:SetKeyValue("iMagnitude", 20)
    
    ex:Fire("explode")

    self:Remove()

    SafeRemoveEntityDelayed(ex, 0.1)

end

function ENT:InitializeModules()
    for i = 0, #self.Modules do

        local moduleName = self.Modules[i] or ""
        
        local moduleManager = BaseWars.Entity.Modules
        local module = moduleManager:Get(moduleName)

        if !module then
            print("Module does not exist!")
            continue
        end

        self:AddModule(module)

        if module.Initialize then
            module:Initialize(self)
        end
    end
end

function ENT:AddModule(module)

    table.insert(self.InitializedModules, module)

end

/*function ENT:RunModules(func)
    for _, module in ipairs(self.Modules) do
        if module[func] then
            module[func](self) 
        end
    end
end*/