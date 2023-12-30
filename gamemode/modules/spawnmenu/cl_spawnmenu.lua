BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

local Player = FindMetaTable("Player")

function Player:BuyEntity(uuid)
    local netTag = BaseWars.SpawnMenu.Net.BuyEntity

    BaseWars.Net.SendToServer(netTag, {uuid = uuid})
end

function Player:SetAutoBuy(bool, weapon)
    local netTag = BaseWars.SpawnMenu.Net.AutoBuy

    BaseWars.Log("Player " .. self:Nick() .. " (" .. self:SteamID() .. ") attempted to set auto buy to " .. tostring(bool) .. " for weapon " .. weapon .. ".")

    BaseWars.Net.SendToServer(netTag, {bool = bool, weapon = weapon})
end