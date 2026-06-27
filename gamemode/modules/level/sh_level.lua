local Player = FindMetaTable("Player")

function Player:GetLevel()
    return self:GetNWInt("level", 0)
end

function Player:CanAffordLevel(level)
    return self:GetLevel() >= level
end

function Player:GetXP()
    return self:GetNWInt("xp", 0)
end

-- Level + XP stuff
/*
    Each levels requires a certain amount of XP to be reached.
    formula is : (level/x)^y
*/

local FORMULAX = BaseWars.Config.Level.FormulaX
local FORMULAY = BaseWars.Config.Level.FormulaY

function Player:GetXPForLevel(level)
    return math.Round((level/FORMULAX)^FORMULAY)
end

function Player:GetXPForNextLevel()
    return self:GetXPForLevel(self:GetLevel() + 1)
end

function Player:GetLevelForXP(xp)
    return math.Round(FORMULAX*(xp^(1/FORMULAY)))
end