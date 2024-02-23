BaseWars = BaseWars or {}
BaseWars.Radar = BaseWars.Radar or {}

function BaseWars.Radar.GetRaidableEntitieWithinRadius(pos, radius)
    local entities = ents.FindInSphere(pos, radius)
    local raidable = {}

    for k, v in pairs(entities) do
        if v.IsPlayer then
            table.insert(raidable, v)
        elseif v.IsBaseWars then
            table.insert(raidable, v)
        end
    end

    return raidable
end

function BaseWars.Radar.FindRaidableEntitiesAroundRadar(radar)
    local pos = radar:GetPos()
    local radius = radar:GetRadarRadius()
    local entities = BaseWars.Radar.GetRaidableEntitieWithinRadius(pos, radius)

    return entities
end

function BaseWars.Radar.SendRaidableEntities(ply, radar)
    local entities = BaseWars.Radar.FindRaidableEntitiesAroundRadar(radar)

    BaseWars.Net.SendToPlayer(ply, BaseWars.Radar.Net.SendRaidableEntities, { entities = entities, radar = radar })
end

function BaseWars.Radar.AskForRaidableEntities(ply, radar)
    BaseWars.Radar.SendRaidableEntities(ply, radar)
end

net.Receive(BaseWars.Radar.Net.AskForRaidableEntities, function(len, ply)
    local data =  BaseWars.Net.Read(BaseWars.Radar.Net.AskForRaidableEntities)
    local radar = data.radar

    if not IsValid(radar) then return end

    BaseWars.Radar.AskForRaidableEntities(ply, radar)
end)