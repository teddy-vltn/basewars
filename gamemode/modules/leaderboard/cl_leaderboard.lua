BaseWars = BaseWars or {}
BaseWars.Leaderboard = BaseWars.Leaderboard or {}

BaseWars.Log("Loading leaderboard module. AAAAAAAAAAAAAAAAAAAAAAAAA")

net.Receive(BaseWars.Leaderboard.Net.RefreshLeaderboard, function(len)
    local data = BaseWars.Net.Read(BaseWars.Leaderboard.Net.RefreshLeaderboard)

    BaseWars.Leaderboard.Cache = data.leaderboard

    BaseWars.Log("Leaderboard refreshed.")
end)

print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')