local Player = FindMetaTable("Player")

BaseWars = BaseWars or {}
BaseWars.Money = BaseWars.Money or {}

/*
    Config
*/

BaseWars.Money.Config = BaseWars.Money.Config or {}

BaseWars.Money.Config.StartAmount = 1000

/*

    Player functions

*/

function Player:CanAfford(amount)
    return self:GetMoney() >= amount
end

function Player:GetMoney()
    return self:GetNWInt("money", BaseWars.Money.Config.StartAmount)
end

