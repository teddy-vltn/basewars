BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

local Player = FindMetaTable("Player")

function Player:BuyEntity(uuid)
    net.Start("BaseWars_BuyEntity")
        net.WriteString(uuid)
    net.SendToServer()
end

function Player:SetAutoBuy(bool, weapon)
    net.Start("BaseWars_AutoBuy")
        net.WriteBool(bool)
        net.WriteString(weapon)
    net.SendToServer()
end