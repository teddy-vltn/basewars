function BaseWars.Props.FindPlayerProps(ply)
    local props = {}

    for _, ent in pairs(ents.GetAll()) do
        if ent.Base == "prop_physics" and ent:CPPIGetOwner() == ply then
            table.insert(props, ent)
        end
    end

    return props
end

-- On prop spawn define the health of the prop
-- based on the gravity of the prop
hook.Add("PlayerSpawnedProp", "BaseWars.Props.SetHealth", function(ply, model, ent)
    local gravity = ent:GetPhysicsObject():GetMass() * 9.81
    local health = gravity * 0.1

    ent:SetMaxHealth(health)
    ent:SetHealth(health)
    ent:SetNWInt("BaseWars_PropMaxHealth", health)

    -- Add the upgradeable module to the prop

    -- A bit of a hacky way to add the upgradeable module to the prop
    -- but it works
    -- we normally would have to make it derive from the base entity bw_base for it to properly work
    -- but we can't do that because it's a prop
    -- so we have to add the module manually, gg no re
    ent.Upgradeable = true
    ent.UpgradeModule = BaseWars.Entity.Modules:Get("Upgradeable")

    function ent:SetUpgradeLevel(level)
        self:SetNWInt("UpgradeLevel", level)
    end

    function ent:GetUpgradeLevel()
        return self:GetNWInt("UpgradeLevel")
    end

    function ent:Upgrade()
        ent.UpgradeModule:Upgrade(ent)

        local upgradeLevel = ent:GetUpgradeLevel()
        local maxHealth = health * upgradeLevel * 2

        ent:SetMaxHealth(maxHealth)
        ent:SetNWInt("BaseWars_PropMaxHealth", maxHealth)
        ent:SetHealth(maxHealth)
    end

    -- ent:Upgrade()
end)

hook.Add("EntityTakeDamage", "BaseWars.Props.TakeDamage", function(ent, dmg)
    if not IsValid(ent) or ent:GetClass() ~= "prop_physics" then return end
    if ent.BaseWarsRaidDisabled then
        dmg:SetDamage(0)
        return true
    end

    local health = ent:Health()
    if health <= 0 then
        local phys = ent:GetPhysicsObject()
        local maxHealth = 100

        if IsValid(phys) then
            maxHealth = math.max(phys:GetMass() * 9.81 * 0.1, 1)
        end

        ent:SetMaxHealth(maxHealth)
        ent:SetNWInt("BaseWars_PropMaxHealth", maxHealth)
        ent:SetHealth(maxHealth)
        health = maxHealth
    end

    local newHealth = health - dmg:GetDamage()
    ent:SetHealth(newHealth)

    if newHealth <= 0 then
        if BaseWars.Raid and BaseWars.Raid.HandleEntityDeath and BaseWars.Raid.HandleEntityDeath(ent, dmg) then
            return true
        end

        ent:Remove()
    end
end)



    
