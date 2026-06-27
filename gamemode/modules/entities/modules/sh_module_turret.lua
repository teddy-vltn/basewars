local BW_TURRET_MODULE = {}
BW_TURRET_MODULE.__index = BW_TURRET_MODULE

-- Constants
local MODULE_NAME = "Turret"
local MODULE_DESC = "Module for turret functionalities"

-- Initialization
function BW_TURRET_MODULE.New()
    local self = setmetatable({}, BW_TURRET_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    
    -- Variables spécifiques à la tourelle, comme le délai entre les tirs, les dégâts, etc.
    self.NetworkVars = {
        {"FireRate", 1, "Float"},
        {"Damage", 10, "Int"}
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_TURRET_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized

    ent.LastTimeFired = 0

    print("Turret module initialized for entity: ", ent)
end

function BW_TURRET_MODULE:OnThink(ent)
    if CLIENT then return end

    if (CurTime() - ent.LastTimeFired) < ent:GetFireRate() then return end

    local turretPos = ent:GetPos()
    local range = ent.Radius
    local turretForward = ent:GetForward()
    local fov = ent.FOV

    -- Chercher des joueurs à proximité
    local targets = ents.FindInSphere(turretPos, range)
    local closestTarget = nil
    local closestDistance = range

    local owner = ent:CPPIGetOwner()

    for _, target in ipairs(targets) do
        if target:IsPlayer() and target:Alive() then

            local targetFaction = target:GetFaction()
            local ownerFaction = owner:GetFaction()

            if targetFaction == ownerFaction then
                continue
            end

            local dist = turretPos:Distance(target:GetPos())
            local directionToTarget = (target:GetPos() - turretPos):GetNormalized()
            local dotProduct = turretForward:Dot(directionToTarget)

            -- Vérifiez si la cible est dans le champ de vision de la tourelle
            if dotProduct > math.cos(math.rad(fov/2)) then  -- 50 est la moitié de 100, car le cosinus fonctionne avec un demi-FOV
                if dist < closestDistance then
                    closestTarget = target
                    closestDistance = dist
                end
            end
        end
    end

    if closestTarget then
        self:FireAtTarget(ent, closestTarget)

        ent.LastTimeFired = CurTime()
    end
end

function BW_TURRET_MODULE:FireAtTarget(ent, target)
    local bullet = {}
    bullet.Num = 1
    bullet.Src = ent:GetPos() + Vector(0, 0, 50)  -- Ajustez pour le point de départ du tir (par exemple, le canon de la tourelle)
    bullet.Dir = (target:GetPos() + Vector(0, 0, 50) - bullet.Src):GetNormalized()  -- Ajustez pour viser le torse du joueur
    bullet.Spread = Vector(0.05, 0.05, 0.05)
    bullet.Tracer = 1
    bullet.Force = 50
    bullet.Damage = ent:GetDamage()
    bullet.AmmoType = "Pistol"

    ent:FireBullets(bullet)

    ent:EmitSound("Weapon_AR2.Single")

    local effectdata = EffectData()
    effectdata:SetOrigin(target:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(3)
    effectdata:SetRadius(2)
    util.Effect("Sparks", effectdata)

end


local turretModuleInstance = BW_TURRET_MODULE.New()
BaseWars.Entity.Modules:Add(turretModuleInstance)
