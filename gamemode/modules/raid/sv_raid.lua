-- Constants
local RAID_PREPARE_TIME = 5 -- 30 seconds before the raid starts
local RAID_TICKET_LOSS_ON_DEATH = 90 -- Points lost when an attacker is killed
local RAID_ENTITY_THRESHOLD = 0.75 -- When entities left < 75%, the raid stops
local GLOBAL_RAID_COOLDOWN = 60 * 60 -- 1 hour cooldown between raids
local BASE_TICKETS = 100 -- 500 tickets = 500 seconds = 8 minutes and 20 seconds
local RAID_DURATION = 500 -- 500 seconds = 8 minutes and 20 seconds

-- Raid class
local Raid = {}
Raid.__index = Raid

-- Helper function to get the count of entities associated with a faction
local function GetEntitiesCount(factionName)
    local faction = BaseWars.Faction.GetFaction(factionName)
    if not faction then
        BaseWars.Log("Invalid faction: " .. factionName)
        return 0
    end

    local factionMembers = faction:GetMembers()
    local count = 0
    for _, player in pairs(factionMembers) do
        count = count + #BaseWars.Entities.FindPlayerEntities(player)
    end

    BaseWars.Log("Found " .. count .. " entities for faction " .. factionName)
    return count
end

-- Constructor for a new raid
function Raid.new(attackerName, defenderName, startingPoints)
    -- Validate factions before creating a new raid
    if not BaseWars.Faction.Exists(attackerName) or not BaseWars.Faction.Exists(defenderName) then
        BaseWars.Log("Attempted to start a raid with one or more invalid factions.")
        return nil
    end

    local self = setmetatable({}, Raid)
    self.Attacker = attackerName
    self.Defender = defenderName

    self.Points = startingPoints

    -- Obtain initial entity count for the attacking faction
    self.BaseEntitiesCountAttacker = GetEntitiesCount(attackerName)
    self.BaseEntitiesCountDefender = GetEntitiesCount(defenderName)
    self.entitiesDestroyedAttacker = 0
    self.entitiesDestroyedDefender = 0

    self.StartTime = CurTime() + RAID_PREPARE_TIME

    self._LastUpdateDataSent = {}

    return self
end

-- Starts the raid preparation phase
function Raid:StartPreparation()
    -- Broadcast the raid preparation to both factions
    local prepMessage = "Raid preparation has begun. The raid will start in " .. RAID_PREPARE_TIME .. " seconds."
    BaseWars.Log(prepMessage)

    -- Prepare the client-side for the raid start
    BaseWars.Net.Broadcast(BaseWars.Raid.Net.StartRaid, {
        attacker = self.Attacker,
        defender = self.Defender,
        start = self.StartTime
    })

    -- Schedule the start of the raid
    timer.Simple(RAID_PREPARE_TIME, function()
        if BaseWars.Raid.CurrentRaid == self then
            self:Start()
        else
            BaseWars.Log("Raid preparation was cancelled or a new raid was started.")
        end
    end)
end

-- Starts the actual raid
function Raid:Start()
    -- Notification for raid start
    local startMessage = "The raid has begun. You have " .. self.Points .. " points."
    BaseWars.Log(startMessage)

    -- Broadcast the raid start to clients
    BaseWars.Net.Broadcast(BaseWars.Raid.Net.RaidHasStarted, {
        start = CurTime(),
        points = self.Points,
        entitiesCountAttacker = self.BaseEntitiesCountAttacker,
        entitiesCountDefender = self.BaseEntitiesCountDefender
    })

    -- Start a timer to update the raid periodically
    timer.Create("Raid_" .. self.Attacker .. "_" .. self.Defender, 1, 0, function()
        self:Update()
    end)
end

-- Stops the raid
function Raid:Stop(winnerFaction, loserFaction, remainingPoints)
    -- Notification for raid end
    local endMessage = "The raid is over. "
    BaseWars.Log(endMessage)

    -- Broadcast the raid stop to clients
    BaseWars.Net.Broadcast(BaseWars.Raid.Net.StopRaid, {
        winner = winnerFaction,
        loser = loserFaction,
        remainingPoints = remainingPoints
    })

    -- Remove the update timer and clear the current raid
    timer.Remove("Raid_" .. self.Attacker .. "_" .. self.Defender)
    BaseWars.Raid.CurrentRaid = nil
    BaseWars.Raid.LastRaidEndTime = CurTime()
end

-- Updates the raid progress
function Raid:Update()

    if not BaseWars.Faction.Exists(self.Attacker) or not BaseWars.Faction.Exists(self.Defender) then
        BaseWars.Log("One or more factions no longer exist. Stopping the raid.")
        self:Stop(self.Defender, self.Attacker, self.Points)
        return
    end

    -- Check if the raid has ended
    if self.StartTime + RAID_DURATION <= CurTime() then
        self:Stop(self.Defender, self.Attacker, 0)
        return
    end

    -- Check if enough entities have been destroyed to stop the raid
    if self.entitiesDestroyedAttacker / self.BaseEntitiesCountAttacker >= RAID_ENTITY_THRESHOLD then
        self:Stop(self.Defender, self.Attacker, self.Points)
    elseif self.entitiesDestroyedDefender / self.BaseEntitiesCountDefender >= RAID_ENTITY_THRESHOLD then
        self:Stop(self.Attacker, self.Defender, self.Points)
    else
        local updateData =  {
            entitiesDestroyedAttacker = self.entitiesDestroyedAttacker,
            entitiesDestroyedDefender = self.entitiesDestroyedDefender,
            points = self.Points
        }

        -- Check if the update data has changed since the last broadcast
        if not table.Equals(updateData, self._LastUpdateDataSent) then
            self._LastUpdateDataSent = table.Copy(updateData)

            -- If not, continue the raid and broadcast the update
            BaseWars.Net.Broadcast(BaseWars.Raid.Net.UpdateRaid, updateData)
        end
    end
end

-- Handles the event when an attacker is killed
function Raid:AttackerKilled(attackerName)
    -- Deduct points for the death of an attacker
    self.Points = self.Points - RAID_TICKET_LOSS_ON_DEATH

    BaseWars.Log("Attacker " .. attackerName .. " was killed. " .. self.Points .. " points remaining.")

    -- If the points reach zero, the raid ends
    if self.Points <= 0 then
        self:Stop(self.Attacker, self.Defender, 0)
    end
end

-- BaseWars Raid system initialization
BaseWars.Raid = BaseWars.Raid or {}
BaseWars.Raid.CurrentRaid = nil
BaseWars.Raid.LastRaidEndTime = 0

function BaseWars.Raid.StartRaid(factionName, targetName, start)
    -- Check if a raid is already in progress
    if BaseWars.Raid.CurrentRaid then
        BaseWars.Log("Attempted to start a raid while one is already in progress.")
        return false, "A raid is already in progress"
    end

    -- Check if the raid is on cooldown
    /*if CurTime() - BaseWars.Raid.LastRaidEndTime < GLOBAL_RAID_COOLDOWN then
        BaseWars.Log("Attempted to start a raid while on cooldown.")
        return false, "Raid is on cooldown"
    end*/

    -- Create a new raid and start the preparation phase
    local raid = Raid.new(factionName, targetName, BASE_TICKETS)
    if raid then
        BaseWars.Raid.CurrentRaid = raid
        raid:StartPreparation()
        return true, "Raid started"
    else
        BaseWars.Log("Attempted to start a raid with invalid factions.")
        return false, "Invalid factions"
    end
end

-- Handles networked requests for starting a raid
net.Receive(BaseWars.Raid.Net.StartRaid, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Raid.Net.StartRaid)

    local status, message = BaseWars.Raid.StartRaid(ply:GetFaction(), data.target, data.start)
    BaseWars.Notify.Send(ply, "Démarrer un raid", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

-- Handles the event when an attacker is killed
hook.Add("PlayerDeath", "BaseWars_RaidAttackerKilled", function(victim, inflictor, attacker)
    if not BaseWars.Raid.CurrentRaid then return end

    local attackerName = attacker:GetFaction()
    
    if attackerName == BaseWars.Raid.CurrentRaid.Attacker then
        BaseWars.Raid.CurrentRaid:AttackerKilled(attackerName)
    end
end)

-- Handles the event when an entity is destroyed
hook.Add("EntityRemoved", "BaseWars_RaidEntityDestroyed", function(ent)
    if not BaseWars.Raid.CurrentRaid then return end

    -- impletment 
end)

-- Handles the event when a player leaves the server
hook.Add("PlayerDisconnected", "BaseWars_RaidPlayerDisconnected", function(ply)
    if not BaseWars.Raid.CurrentRaid then return end

    -- implement
end)

-- test commands for the raid system
concommand.Add("bw_test_start_raid", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end

    -- get two players from the server
    local secondPlayer = player.GetAll()[2]

    -- create a faction between the two players
    local state, err = BaseWars.Faction.CreateFaction("MeMeMe", "", Color(255, 0, 0), "icon16/gun.png", ply)
    BaseWars.Log("Create faction: " .. tostring(state) .. " - " .. err)
    state, err = BaseWars.Faction.CreateFaction("YouYouYou", "", Color(0, 255, 0), "icon16/gun.png", secondPlayer)
    BaseWars.Log("Create faction: " .. tostring(state) .. " - " .. err)

    -- start a raid between the two factions

    local status, message = BaseWars.Raid.StartRaid("MeMeMe", "YouYouYou", CurTime() + 5)
    BaseWars.Notify.Send(ply, "Démarrer un raid", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

