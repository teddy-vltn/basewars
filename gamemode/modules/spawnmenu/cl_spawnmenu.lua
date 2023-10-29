BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

local Player = FindMetaTable("Player")

function Player:BuyEntity(class)
    net.Start("BaseWars_BuyEntity")
        net.WriteString(class)
    net.SendToServer()
end