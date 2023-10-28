local BW_UPGRADE_MODULE = {}

BW_UPGRADE_MODULE.Name = "Upgrade"
BW_UPGRADE_MODULE.Description = "Allows you to upgrade your entity"

BW_UPGRADE_MODULE.NetworkVars = {
    {"UpgradeLevel", 0, "Int"}
}

function BW_UPGRADE_MODULE.Initialize(ent)
    print("Upgrade module initialized")
end

function BW_UPGRADE_MODULE.OnTakeDamage(ent, dmg)
    local upgradeLevel = ent:GetNWInt("UpgradeLevel")
    if upgradeLevel > 1 then
        dmg:ScaleDamage(1/upgradeLevel) -- Example: reduce damage based on upgrade level
    end
end

function BW_UPGRADE_MODULE.Upgrade(ent)
    local currentLevel = ent:GetNWInt("UpgradeLevel")
    ent:SetNWInt("UpgradeLevel", currentLevel + 1)
end

BaseWars.Entity.Modules:Add(BW_UPGRADE_MODULE.Name, BW_UPGRADE_MODULE)