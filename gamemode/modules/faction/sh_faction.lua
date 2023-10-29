BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

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
    return self.Faction
end