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
    return self:GetNWString("Faction")
end

function BaseWars.Faction.HasFactionPassword(name)
    local factionTable = BaseWars.Faction.GetFaction(name)
    if not factionTable then return false end

    if CLIENT then return factionTable.Password else return factionTable.Password != "" end
end