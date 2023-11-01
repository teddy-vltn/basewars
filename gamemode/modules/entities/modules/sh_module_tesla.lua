local BW_TESLA_MODULE = {}
BW_TESLA_MODULE.__index = BW_TESLA_MODULE

-- Constants
local MODULE_NAME = "Tesla"
local MODULE_DESC = "Electrocutes nearby enemies"
local EFFECT_RADIUS = 300  -- distance à laquelle la tourelle peut détecter et attaquer les ennemis

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

    -- Trouver tous les joueurs dans le rayon d'effet
    local targets = ents.FindInSphere(teslaPos, EFFECT_RADIUS)
    for _, target in pairs(targets) do
        if target:IsPlayer() and target:Alive() then  -- Assurez-vous que la cible est un joueur vivant
            -- Appliquer des dégâts à la cible
            local damage = DamageInfo()
            damage:SetDamage(5)  -- Dégâts par seconde, à ajuster
            damage:SetAttacker(ent)
            damage:SetInflictor(ent)
            damage:SetDamageType(DMG_SHOCK)
            target:TakeDamageInfo(damage)

            -- Afficher l'effet visuel de l'éclair
            local effectData = EffectData()
            effectData:SetStart(teslaPos)
            effectData:SetOrigin(target:GetPos())
            effectData:SetMagnitude(5)
            effectData:SetScale(1)
            effectData:SetRadius(5)
            util.Effect("TeslaHitBoxes", effectData, true, true)
        end
    end

    for i = 1, 10 do  -- Génère 10 étincelles, ajustez ce nombre au besoin
        local sparkPos = teslaPos + Vector(math.random(-EFFECT_RADIUS, EFFECT_RADIUS), math.random(-EFFECT_RADIUS, EFFECT_RADIUS), 0)
        local effectData = EffectData()
        effectData:SetOrigin(sparkPos)
        effectData:SetMagnitude(1)
        effectData:SetScale(0.2)
        util.Effect("Sparks", effectData)
    end
end

local teslaModuleInstance = BW_TESLA_MODULE.New()
BaseWars.Entity.Modules:Add(teslaModuleInstance)
