BaseWars = BaseWars or {}
BaseWars.Entities = BaseWars.Entities or {}

BaseWars.Entities.Net = {
    Sell = "BaseWars_SellEntity",
    Upgrade = "BaseWars_UpgradeEntity"
}

BaseWars.Net.Register(BaseWars.Entities.Net.Sell, { entity = "Entity" })
BaseWars.Net.Register(BaseWars.Entities.Net.Upgrade, { entity = "Entity" })

properties.Add("bw_base_sell", {
    MenuLabel = "Sell ",
    Order = 999,
    MenuIcon = "icon16/money_delete.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then return false end
        if not ent:CanSell() then return false end
        self.MenuLabel = "Sell for $" .. ent:GetValue()
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

