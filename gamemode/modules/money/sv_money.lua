local Player = FindMetaTable("Player")

function Player:AddMoney(amount)
    self:SetNWInt("money", self:GetMoney() + amount)
end

function Player:TakeMoney(amount)
    self:SetNWInt("money", self:GetMoney() - amount)
end

function Player:SetMoney(amount)
    self:SetNWInt("money", amount)
end

function Player:GiveMoney(amount)
    self:AddMoney(amount)
end

hook.Add("PlayerInitialSpawn", "BaseWars.Money.PlayerInitialSpawn", function(ply)
    ply:LoadData()
end)

hook.Add("PlayerDisconnected", "BaseWars.Money.PlayerDisconnected", function(ply)
    ply:SaveData()
end)