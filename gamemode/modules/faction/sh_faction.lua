BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

Faction = {}
Faction.__index = Faction

function Faction.new(name, password, color, icon, leader)
    local self = setmetatable({}, Faction)

    self.Name = name
    self.Password = password
    self.Color = color
    self.Icon = icon
    self.Members = {
        [leader] = true
    }
    self.Leader = leader

    return self
end

function Faction.__eq(a, b)
    return a.Name == b.Name
end

function Faction.__tostring(self)
    return self.Name
end

function Faction:GetMembers()
    return self.Members
end

function Faction:GetName()
    return self.Name
end

function Faction:HasPassword()
    return self.Password ~= ""
end

function Faction:GetPassword()
    return self.Password
end

function Faction:GetColor()
    return self.Color
end

function Faction:GetIcon()
    return self.Icon
end

function Faction:GetLeader()
    return self.Leader
end

function Faction:GetMemberCount()
    return table.Count(self.Members)
end

local Player = FindMetaTable("Player")

function BaseWars.Faction.GetFactions()
    return BaseWars.Faction.Factions
end

function BaseWars.Faction.GetFaction(name)
    return BaseWars.Faction.Factions[name]
end

function BaseWars.Faction.GetFactionByMember(ply)
    for k, v in pairs(BaseWars.Faction.Factions) do
        if v.Members[ply] then
            return v
        end
    end
end

function Player:GetFaction()
    return self:GetNWString("Faction")
end

function Player:IsFriendlyEntity(ent)

    return false
end
