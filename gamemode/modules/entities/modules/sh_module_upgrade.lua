local BW_UPGRADE_MODULE = {}

BW_UPGRADE_MODULE.Name = "Upgradeable"
BW_UPGRADE_MODULE.Description = "Allows you to upgrade your entity"

BW_UPGRADE_MODULE.NetworkVars = {
    {"UpgradeLevel", 0, "Int"}
}

function BW_UPGRADE_MODULE.Initialize(ent)
    print("Upgrade module initialized")
end

function BW_UPGRADE_MODULE.Upgrade(ent)
    ent:SetUpgradeLevel(ent:GetUpgradeLevel() + 1)
end

BaseWars.Entity.Modules:Add(BW_UPGRADE_MODULE.Name, BW_UPGRADE_MODULE)