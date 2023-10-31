BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

local Player = FindMetaTable("Player")

function Player:BuyEntity(uuid)
    net.Start("BaseWars_BuyEntity")
        net.WriteString(uuid)
    net.SendToServer()
end