local Player = FindMetaTable("Player")

BaseWars = BaseWars or {}
BaseWars.Level = BaseWars.Level or {}

function Player:SetLevel(level)
    self:SetNWInt("level", level)
end

function Player:AddLevel(level)
    self:SetLevel(self:GetLevel() + level)
end

function Player:TakeLevel(level)
    self:SetLevel(self:GetLevel() - level)
end

-- XP stuff

function Player:SetXP(xp)
    self:SetNWInt("xp", xp)
end

function Player:AddXP(xp)
    self:SetXP(self:GetXP() + xp)

    local xpNeeded = self:GetXPForNextLevel()
    if self:GetXP() >= xpNeeded then
        self:SetLevel(self:GetLevel() + 1)

        -- If the player has more XP than needed for the next level, we remove the excess XP
        -- this prevent skipping levels by adding a lot of XP at once
        self:SetXP(0)
    end
end

function Player:TakeXP(xp)
    self:SetXP(self:GetXP() - xp)
end

-- Level + XP stuff
/*
    Each levels requires a certain amount of XP to be reached.
    formula is : (level/x)^y
*/



