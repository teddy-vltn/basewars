BaseWars = BaseWars or {}
BaseWars.Raid = BaseWars.Raid or {}

BaseWars.Raid.Net = BaseWars.Raid.Net or {
    RequestStartRaid = "Raid_RequestStartRaid",
    StartRaid = "Raid_StartRaid",
    RaidHasStarted = "Raid_RaidHasStarted",
    StopRaid = "Raid_StopRaid",

    UpdateRaid = "Raid_UpdateRaid",
    AttackerHasBeenKilled = "Raid_AttackerHasBeenKilled",
    RepairEntity = "Raid_RepairEntity"
}

BaseWars.Net.Register(BaseWars.Raid.Net.RequestStartRaid, { target = "Entity" })

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

BaseWars.Net.Register(BaseWars.Raid.Net.RepairEntity, { entity = "Entity" })

function BaseWars.Raid.GetRemainingTime(time, points)
    return points - (CurTime() - time)
end

function BaseWars.Raid.GetRemainingPoints(time, points)
    return math.floor(BaseWars.Raid.GetRemainingTime(time, points))
end

function BaseWars.Raid.GetEntityValue(ent)
    if not IsValid(ent) or not ent.GetValue then return 0 end
    return math.max(ent:GetValue() or 0, 0)
end

if CLIENT then
    function BaseWars.Raid.TryStartRaid(target)
        BaseWars.Net.SendToServer(BaseWars.Raid.Net.RequestStartRaid, { target = target })
    end

    function BaseWars.Raid.TryRepairEntity(ent)
        BaseWars.Net.SendToServer(BaseWars.Raid.Net.RepairEntity, { entity = ent })
    end

    properties.Add("bw_raid_repair", {
        MenuLabel = "Repair",
        Order = 998,
        MenuIcon = "icon16/wrench.png",
        Filter = function(self, ent, ply)
            if not IsValid(ent) then return false end
            if not ent:GetNWBool("BaseWars_RaidDisabled", false) then return false end
            if ent.CPPIGetOwner and ent:CPPIGetOwner() ~= ply and not ply:IsFriendlyEntity(ent) then return false end

            local cost = ent:GetNWInt("BaseWars_RaidRepairCost", 0)
            self.MenuLabel = "Repair for $" .. BaseWars.NumberFormat(cost)
            return true
        end,
        Action = function(self, ent)
            BaseWars.Raid.TryRepairEntity(ent)
        end
    })
end
