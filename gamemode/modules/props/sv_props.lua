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

        ent:SetMaxHealth(health * upgradeLevel * 2)
        ent:SetHealth(health * upgradeLevel * 2)
    end

    -- ent:Upgrade()
end)



    