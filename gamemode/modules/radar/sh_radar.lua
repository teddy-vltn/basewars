BaseWars = BaseWars or {}
BaseWars.Radar = BaseWars.Radar or {}

BaseWars.Radar.Net = BaseWars.Radar.Net or {
    AskForRaidableEntities = "Radar_AskForRaidableEntities",
    SendRaidableEntities = "Radar_SendRaidableEntities"
}

BaseWars.Net.Register(BaseWars.Radar.Net.AskForRaidableEntities, { radar = "Entity" })
BaseWars.Net.Register(BaseWars.Radar.Net.SendRaidableEntities, { entities = "table", radar = "Entity" })
