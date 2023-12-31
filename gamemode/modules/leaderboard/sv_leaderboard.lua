BaseWars = BaseWars or {}
BaseWars.Leaderboard = BaseWars.Leaderboard or {}

BaseWars.Leaderboard.MaxPages = 2
BaseWars.Leaderboard.RefreshRate = 300
BaseWars.Leaderboard.NextRefresh = nil

function BaseWars.Leaderboard.RefreshPage(page)
    BaseWars.Persist.GetTopPlayers(page, function(data)
        BaseWars.Leaderboard.Cache[page] = data
    end)
end

function BaseWars.Leaderboard.Send(ply)
    BaseWars.Net.SendToPlayer(ply, BaseWars.Leaderboard.Net.RefreshLeaderboard, {
        leaderboard = BaseWars.Leaderboard.Cache
    })
end

function BaseWars.Leaderboard.Refresh()
    for i = 0, BaseWars.Leaderboard.MaxPages do
        BaseWars.Leaderboard.RefreshPage(i)
    end

    BaseWars.Net.Broadcast(BaseWars.Leaderboard.Net.RefreshLeaderboard, {
        leaderboard = BaseWars.Leaderboard.Cache
    })

    BaseWars.Log("Leaderboard refreshed.")
end

function BaseWars.Leaderboard.Think()
    if not BaseWars.Leaderboard.NextRefresh then
        BaseWars.Leaderboard.Refresh()
        BaseWars.Leaderboard.NextRefresh = CurTime() + BaseWars.Leaderboard.RefreshRate
    end

    if CurTime() >= BaseWars.Leaderboard.NextRefresh then
        BaseWars.Leaderboard.Refresh()
        BaseWars.Leaderboard.NextRefresh = CurTime() + BaseWars.Leaderboard.RefreshRate
    end
end
