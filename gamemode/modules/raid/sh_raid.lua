BaseWars = BaseWars or {}
BaseWars.Raid = BaseWars.Raid or {}

BaseWars.Raid.Net = BaseWars.Raid.Net or {
    StartRaid = "Raid_StartRaid",
    RaidHasStarted = "Raid_RaidHasStarted",
    StopRaid = "Raid_StopRaid",

    UpdateRaid = "Raid_UpdateRaid",
    AttackerHasBeenKilled = "Raid_AttackerHasBeenKilled"
}

-- When a raid is started, we send the faction name, the target name, the starting points (which is the duration: "tickets system" 
-- and the start time to the client (we don't start the raid instantly, we wait 30 seconds before starting it)
BaseWars.Net.Register(BaseWars.Raid.Net.StartRaid, { attacker = "string", defender = "string", start = "number" })

-- When a raid has started, we send the start time to the client
BaseWars.Net.Register(BaseWars.Raid.Net.RaidHasStarted, { start = "number", points = "number", 
                                    entitiesCountAttacker = "number", entitiesCountDefender = "number"})

-- When a raid is stopped, we send the faction name and the target name to the client
BaseWars.Net.Register(BaseWars.Raid.Net.StopRaid, { winner = "string", loser = "string", remainingPoints = "number" })

-- When the raid is updated, we send the number of entities destroyed
-- when the number of entities left is < 75% of the starting entities we stop the raid
BaseWars.Net.Register(BaseWars.Raid.Net.UpdateRaid, { entitiesDestroyedAttacker = "number", entitiesDestroyedDefender = "number"})

-- When an attacker is killed, we send the attacker's name to the client and remove "x" points from the timer
BaseWars.Net.Register(BaseWars.Raid.Net.AttackerHasBeenKilled, { attacker = "string", points = "number" })

function BaseWars.Raid.GetRemainingTime(time, points)
    return points - (CurTime() - time)
end

function BaseWars.Raid.GetRemainingPoints(time, points)
    return math.floor(BaseWars.Raid.GetRemainingTime(time, points))
end

