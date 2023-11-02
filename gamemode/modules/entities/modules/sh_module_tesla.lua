local BW_TESLA_MODULE = {}
BW_TESLA_MODULE.__index = BW_TESLA_MODULE

-- Constants
local MODULE_NAME = "Tesla"
local MODULE_DESC = "Electrocutes nearby enemies" 

-- Initialization
function BW_TESLA_MODULE.New()
    local self = setmetatable({}, BW_TESLA_MODULE)

    self.NetworkVars = {
        {"FireRate", 1, "Float"},
        {"Damage", 10, "Int"}
    }
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    
    return self
end

function BW_TESLA_MODULE:Initialize(ent)
    -- Initialization logic here
end

function BW_TESLA_MODULE:OnThink(ent)
    if CLIENT then return end

    local teslaPos = ent:GetPos()
    local radius = ent.Radius

    -- Trouver tous les joueurs dans le rayon d'effet
    local targets = ents.FindInSphere(teslaPos, radius)
    for _, target in pairs(targets) do
        if target:IsPlayer() and target:Alive() then  -- Assurez-vous que la cible est un joueur vivant
            -- Appliquer des dégâts à la cible
            local damage = DamageInfo()
            damage:SetDamage(ent:GetDamage())  -- Dégâts par seconde, à ajuster
            damage:SetAttacker(ent)
            damage:SetInflictor(ent)
            damage:SetDamageType(DMG_SHOCK)
            target:TakeDamageInfo(damage)

            -- emitsound 
            ent:EmitSound("ambient/energy/zap"..math.random(1, 9)..".wav", 100, 100)

            for i = 1, 10 do  -- Génère 10 étincelles, ajustez ce nombre au besoin
                local sparkPos = teslaPos + Vector(math.random(-radius, radius), math.random(-radius, radius), 0)
                local effectData = EffectData()
                effectData:SetOrigin(sparkPos)
                effectData:SetMagnitude(2)
                effectData:SetScale(7)
                util.Effect("Sparks", effectData)
            end
        end
    end
end

local teslaModuleInstance = BW_TESLA_MODULE.New()
BaseWars.Entity.Modules:Add(teslaModuleInstance)
