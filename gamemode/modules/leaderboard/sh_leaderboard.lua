BaseWars = BaseWars or {}
BaseWars.Leaderboard = BaseWars.Leaderboard or {}

BaseWars.Leaderboard.Net = BaseWars.Leaderboard.Net or {
    RefreshLeaderboard = "BaseWars_RefreshLeaderboard",
}

BaseWars.Net.Register(BaseWars.Leaderboard.Net.RefreshLeaderboard, {
    leaderboard = "table"
})

BaseWars.Leaderboard.Cache = {}


