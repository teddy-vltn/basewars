BaseWars = BaseWars or {}
BaseWars.Entities = BaseWars.Entities or {}

BaseWars.Entities.Net = {
    Sell = "BaseWars_SellEntity",
    Upgrade = "BaseWars_UpgradeEntity"
}

BaseWars.Net.Register(BaseWars.Entities.Net.Sell, { entity = "Entity" })
BaseWars.Net.Register(BaseWars.Entities.Net.Upgrade, { entity = "Entity" })

function BaseWars.Entities.GetHealthFraction(ent)
    if not IsValid(ent) then return 0 end

    local maxHealth = ent.GetMaxHealth and ent:GetMaxHealth() or 0
    if not maxHealth or maxHealth <= 0 then
        maxHealth = ent.PresetMaxHealth or ent:GetNWInt("BaseWars_PropMaxHealth", 0)
    end
    if not maxHealth or maxHealth <= 0 then return 1 end

    return math.Clamp(ent:Health() / maxHealth, 0, 1)
end

function BaseWars.Entities.GetSellValue(ent)
    if not IsValid(ent) or not ent.GetValue then return 0 end
    return math.floor((ent:GetValue() or 0) * BaseWars.Entities.GetHealthFraction(ent))
end

properties.Add("bw_base_sell", {
    MenuLabel = "Sell ",
    Order = 999,
    MenuIcon = "icon16/money_delete.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then return false end
        if not ent:CanSell() then return false end
        self.MenuLabel = "Sell for $" .. BaseWars.Entities.GetSellValue(ent)
        return true
    end,
    Action = function(self, ent)
        print("Selling entity")
        BaseWars.Net.SendToServer(BaseWars.Entities.Net.Sell, { entity = ent })
    end
})

function BaseWars.Entities.GetUpgradeCost(ent)
    return ent:GetUpgradeLevel() * ent:GetValue()
end

properties.Add("bw_base_upgrade", {
    MenuLabel = "Upgrade",
    Order = 999,
    MenuIcon = "icon16/arrow_up.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then return false end
        if not ent:CanUpgrade() then return false end
        self.MenuLabel = "Upgrade for $" .. BaseWars.Entities.GetUpgradeCost(ent)
        return true
    end,
    Action = function(self, ent)
        BaseWars.Net.SendToServer(BaseWars.Entities.Net.Upgrade, { entity = ent })
    end
})
