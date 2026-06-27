BaseWars = BaseWars or {}
BaseWars.Radar = BaseWars.Radar or {}

-- Cache for raidable entities radar entities
BaseWars.Radar.Radars = BaseWars.Radar.Radars or {}

local function radarEntityToString(radar)
    return radar:EntIndex()
end

local function getRaidableEntities(radar)
    return BaseWars.Radar.Radars[radarEntityToString(radar)] or {}
end

net.Receive(BaseWars.Radar.Net.SendRaidableEntities, function(len)
    local data = BaseWars.Net.Read(BaseWars.Radar.Net.SendRaidableEntities)

    local entities = data.entities
    local radar = data.radar

    if not IsValid(radar) then return end

    BaseWars.Radar.Radars[radarEntityToString(radar)] = entities

    OpenRadarMenu(radar)
end)

print("Radar module loaded!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
