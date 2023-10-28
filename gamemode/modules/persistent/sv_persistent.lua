-- used for saving and loading persistent data for players

local Player = FindMetaTable("Player")

function Player:SaveData()
    local data = {}

    data.money = self:GetMoney()

    file.Write("basewars/playerdata/" .. self:SteamID64() .. ".txt", util.TableToJSON(data))
end

function Player:LoadData()
    local data = util.JSONToTable(file.Read("basewars/playerdata/" .. self:SteamID64() .. ".txt", "DATA") or "{}")

    self:SetMoney(data.money or BaseWars.Money.Config.StartAmount)
end

