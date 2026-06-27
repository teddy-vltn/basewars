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
