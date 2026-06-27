local RAID_PREPARE_TIME = 5
local RAID_TICKET_LOSS_ON_DEATH = 90
local RAID_ENTITY_THRESHOLD = 0.75
local BASE_TICKETS = 100
local RAID_DURATION = 500

local DEFENDER_DESTROY_REWARD = 0.10
local ATTACKER_ENTITY_DESTROY_REWARD = 0.25
local DEFENDER_REPAIR_COST = 0.50
local RESTORE_HEALTH_PERCENT = 0.26

local Raid = {}
Raid.__index = Raid

BaseWars.Raid = BaseWars.Raid or {}
BaseWars.Raid.CurrentRaid = nil
BaseWars.Raid.LastRaidEndTime = 0

local function IsProp(ent)
    if not IsValid(ent) then return false end
    return ent:GetClass() == "prop_physics" or ent.Base == "prop_physics"
end

local function IsBaseWarsEntity(ent)
    return IsValid(ent) and ent.IsBaseWars and ent:IsBaseWars()
end

local function IsRaidableEntity(ent)
    return IsBaseWarsEntity(ent) or IsProp(ent)
end

local function GetOwner(ent)
    if not IsValid(ent) or not ent.CPPIGetOwner then return nil end
    local owner = ent:CPPIGetOwner()
    if not IsValid(owner) or not owner:IsPlayer() then return nil end
    return owner
end

local function GetOwnerFactionName(ent)
    local owner = GetOwner(ent)
    if not owner then return nil end

    local faction = BaseWars.Faction.GetFactionByMember(owner)
    return faction and faction:GetName() or nil
end

local function PayFaction(factionName, amount)
    amount = math.floor(amount or 0)
    if amount <= 0 then return end

    local faction = BaseWars.Faction.GetFaction(factionName)
    if not faction then return end

    local members = BaseWars.Faction.GetOnlineMembers(faction)
    if #members == 0 then return end

    local share = math.floor(amount / #members)
    if share <= 0 then
        members[1]:AddMoney(amount)
        return
    end

    for _, ply in ipairs(members) do
        ply:AddMoney(share)
    end
end

local function GetMaxHealth(ent)
    if not IsValid(ent) then return 1 end
    local maxHealth = ent.GetMaxHealth and ent:GetMaxHealth() or ent:GetNWInt("BaseWars_PropMaxHealth", 0)
    if not maxHealth or maxHealth <= 0 then
        maxHealth = math.max(ent:Health(), 1)
    end
    return maxHealth
end

local function CountFactionEntities(factionName)
    local count = 0

    for _, ent in ipairs(ents.GetAll()) do
        if IsRaidableEntity(ent) and GetOwnerFactionName(ent) == factionName then
            count = count + 1
        end
    end

    return count
end

local function DisableEntity(ent, repairable)
    ent.BaseWarsRaidDisabled = true
    ent.BaseWarsRaidRepairable = repairable
    ent.BaseWarsRaidOldNoDraw = ent:GetNoDraw()
    ent.BaseWarsRaidOldCollisionGroup = ent:GetCollisionGroup()
    ent.BaseWarsRaidOldSolid = ent:GetSolid()
    ent.BaseWarsRaidOldMoveType = ent:GetMoveType()
    ent.BaseWarsRaidMaxHealth = GetMaxHealth(ent)

    local value = BaseWars.Raid.GetEntityValue(ent)
    local repairCost = repairable and math.floor(value * DEFENDER_REPAIR_COST) or 0

    ent:SetNWBool("BaseWars_RaidDisabled", true)
    ent:SetNWInt("BaseWars_RaidRepairCost", repairCost)
    ent:SetHealth(1)
    ent:SetNoDraw(true)
    ent:SetNotSolid(true)
    ent:SetMoveType(MOVETYPE_NONE)
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

local function RestoreEntity(ent, repaired)
    if not IsValid(ent) then return end

    local maxHealth = ent.BaseWarsRaidMaxHealth or GetMaxHealth(ent)
    local health = math.max(math.floor(maxHealth * RESTORE_HEALTH_PERCENT), 1)

    ent.BaseWarsRaidDisabled = nil
    ent.BaseWarsRaidRepairable = nil
    ent.BaseWarsRaidCounted = nil
    ent.Destroyed = nil

    ent:SetNWBool("BaseWars_RaidDisabled", false)
    ent:SetNWInt("BaseWars_RaidRepairCost", 0)
    ent:SetNoDraw(ent.BaseWarsRaidOldNoDraw or false)
    ent:SetNotSolid(false)
    ent:SetSolid(ent.BaseWarsRaidOldSolid or SOLID_VPHYSICS)
    ent:SetMoveType(ent.BaseWarsRaidOldMoveType or MOVETYPE_VPHYSICS)
    ent:SetCollisionGroup(ent.BaseWarsRaidOldCollisionGroup or COLLISION_GROUP_NONE)
    ent:SetHealth(health)

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(true)
        phys:Wake()
    end
end

function Raid.new(attackerName, defenderName, startingPoints)
    if not BaseWars.Faction.Exists(attackerName) or not BaseWars.Faction.Exists(defenderName) then return nil end
    if attackerName == defenderName then return nil end

    local self = setmetatable({}, Raid)
    self.Attacker = attackerName
    self.Defender = defenderName
    self.Points = startingPoints
    self.BaseEntitiesCountAttacker = CountFactionEntities(attackerName)
    self.BaseEntitiesCountDefender = CountFactionEntities(defenderName)
    self.entitiesDestroyedAttacker = 0
    self.entitiesDestroyedDefender = 0
    self.StartTime = CurTime() + RAID_PREPARE_TIME
    self.Started = false
    self.DisabledEntities = {}
    self.AttackerPropsToRestore = {}
    self._LastUpdateDataSent = {}

    return self
end

function Raid:GetTimerName()
    return "Raid_" .. self.Attacker .. "_" .. self.Defender
end

function Raid:StartPreparation()
    BaseWars.Net.Broadcast(BaseWars.Raid.Net.StartRaid, {
        attacker = self.Attacker,
        defender = self.Defender,
        start = math.floor(self.StartTime)
    })

    timer.Simple(RAID_PREPARE_TIME, function()
        if BaseWars.Raid.CurrentRaid == self then
            self:Start()
        end
    end)
end

function Raid:Start()
    self.Started = true

    BaseWars.Net.Broadcast(BaseWars.Raid.Net.RaidHasStarted, {
        start = math.floor(CurTime()),
        points = self.Points,
        entitiesCountAttacker = self.BaseEntitiesCountAttacker,
        entitiesCountDefender = self.BaseEntitiesCountDefender
    })

    timer.Create(self:GetTimerName(), 1, 0, function()
        if BaseWars.Raid.CurrentRaid == self then
            self:Update()
        end
    end)
end

function Raid:Stop(winnerFaction, loserFaction, remainingPoints)
    for ent in pairs(self.AttackerPropsToRestore) do
        RestoreEntity(ent, false)
    end

    BaseWars.Net.Broadcast(BaseWars.Raid.Net.StopRaid, {
        winner = winnerFaction or "",
        loser = loserFaction or "",
        remainingPoints = remainingPoints or 0
    })

    timer.Remove(self:GetTimerName())
    BaseWars.Raid.CurrentRaid = nil
    BaseWars.Raid.LastRaidEndTime = CurTime()
end

function Raid:BroadcastUpdate()
    local updateData = {
        entitiesDestroyedAttacker = self.entitiesDestroyedAttacker,
        entitiesDestroyedDefender = self.entitiesDestroyedDefender,
        points = self.Points
    }

    if table.Equals(updateData, self._LastUpdateDataSent) then return end

    self._LastUpdateDataSent = table.Copy(updateData)
    BaseWars.Net.Broadcast(BaseWars.Raid.Net.UpdateRaid, updateData)
end

function Raid:Update()
    if not BaseWars.Faction.Exists(self.Attacker) or not BaseWars.Faction.Exists(self.Defender) then
        self:Stop(self.Defender, self.Attacker, self.Points)
        return
    end

    if self.StartTime + RAID_DURATION <= CurTime() then
        self:Stop(self.Defender, self.Attacker, 0)
        return
    end

    local attackerLost = self.BaseEntitiesCountAttacker > 0 and self.entitiesDestroyedAttacker / self.BaseEntitiesCountAttacker >= RAID_ENTITY_THRESHOLD
    local defenderLost = self.BaseEntitiesCountDefender > 0 and self.entitiesDestroyedDefender / self.BaseEntitiesCountDefender >= RAID_ENTITY_THRESHOLD

    if attackerLost then
        self:Stop(self.Defender, self.Attacker, self.Points)
    elseif defenderLost then
        self:Stop(self.Attacker, self.Defender, self.Points)
    else
        self:BroadcastUpdate()
    end
end

function Raid:AttackerKilled(attackerName)
    self.Points = self.Points - RAID_TICKET_LOSS_ON_DEATH

    BaseWars.Net.Broadcast(BaseWars.Raid.Net.AttackerHasBeenKilled, {
        attacker = attackerName,
        points = self.Points
    })

    if self.Points <= 0 then
        self:Stop(self.Defender, self.Attacker, 0)
    end
end

function Raid:CountDestroyed(factionName)
    if factionName == self.Attacker then
        self.entitiesDestroyedAttacker = self.entitiesDestroyedAttacker + 1
    elseif factionName == self.Defender then
        self.entitiesDestroyedDefender = self.entitiesDestroyedDefender + 1
    end

    self:BroadcastUpdate()
end

function Raid:HandleEntityDestroyed(ent)
    if not self.Started or not IsRaidableEntity(ent) or ent.BaseWarsRaidCounted then return false end

    local ownerFaction = GetOwnerFactionName(ent)
    if ownerFaction ~= self.Attacker and ownerFaction ~= self.Defender then return false end

    local value = BaseWars.Raid.GetEntityValue(ent)
    ent.BaseWarsRaidCounted = true
    self:CountDestroyed(ownerFaction)

    if ownerFaction == self.Defender then
        PayFaction(self.Attacker, value * DEFENDER_DESTROY_REWARD)
        DisableEntity(ent, true)
        self.DisabledEntities[ent] = true
        return true
    end

    if IsProp(ent) then
        DisableEntity(ent, false)
        self.AttackerPropsToRestore[ent] = true
        return true
    end

    PayFaction(self.Defender, value * ATTACKER_ENTITY_DESTROY_REWARD)
    ent.BaseWarsNoDestroyRefund = true
    return false
end

function BaseWars.Raid.HandleEntityDeath(ent, dmg)
    if not BaseWars.Raid.CurrentRaid then return false end
    return BaseWars.Raid.CurrentRaid:HandleEntityDestroyed(ent)
end

function BaseWars.Raid.StartRaid(attackerName, defenderName)
    if BaseWars.Raid.CurrentRaid then return false, BaseWars.Lang("RaidAlreadyInProgress") end
    if not attackerName or attackerName == "" then return false, BaseWars.Lang("NotInFaction") end
    if not defenderName or defenderName == "" then return false, BaseWars.Lang("RaidInvalidTarget") end
    if attackerName == defenderName then return false, BaseWars.Lang("RaidOwnFaction") end

    local raid = Raid.new(attackerName, defenderName, BASE_TICKETS)
    if not raid then return false, BaseWars.Lang("RaidInvalidTarget") end

    BaseWars.Raid.CurrentRaid = raid
    raid:StartPreparation()

    return true, BaseWars.Lang("RaidStarted")
end

function BaseWars.Raid.StartRaidAgainstEntity(ply, target)
    if not IsValid(target) then return false, BaseWars.Lang("RaidInvalidTarget") end

    local attackerName = ply:GetFaction()
    local defenderName = GetOwnerFactionName(target)

    return BaseWars.Raid.StartRaid(attackerName, defenderName)
end

net.Receive(BaseWars.Raid.Net.RequestStartRaid, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Raid.Net.RequestStartRaid)
    local status, message = BaseWars.Raid.StartRaidAgainstEntity(ply, data.target)

    BaseWars.Notify.Send(ply, BaseWars.Lang("Raid"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

net.Receive(BaseWars.Raid.Net.RepairEntity, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Raid.Net.RepairEntity)
    local ent = data.entity

    if not IsValid(ent) or not ent.BaseWarsRaidDisabled or not ent.BaseWarsRaidRepairable then return end

    local owner = GetOwner(ent)
    if owner ~= ply and not ply:IsFriendlyEntity(ent) then return end

    local cost = ent:GetNWInt("BaseWars_RaidRepairCost", 0)
    if cost > 0 and not ply:CanAfford(cost) then
        BaseWars.Notify.Send(ply, BaseWars.Lang("Repair"), BaseWars.Lang("NotEnoughMoney"), Color(255, 0, 0))
        return
    end

    if cost > 0 then
        ply:TakeMoney(cost)
    end

    RestoreEntity(ent, true)
    BaseWars.Notify.Send(ply, BaseWars.Lang("Repair"), BaseWars.Lang("EntityRepaired"), Color(0, 255, 0))
end)

hook.Add("PlayerDeath", "BaseWars_RaidAttackerKilled", function(victim, inflictor, attacker)
    local raid = BaseWars.Raid.CurrentRaid
    if not raid or not IsValid(attacker) or not attacker:IsPlayer() then return end

    if attacker:GetFaction() == raid.Attacker then
        raid:AttackerKilled(attacker:Nick())
    end
end)

hook.Add("EntityRemoved", "BaseWars_RaidEntityDestroyed", function(ent)
    if not BaseWars.Raid.CurrentRaid then return end
    if ent.BaseWarsRaidDisabled then return end
    if ent.BaseWarsRaidCounted then return end

    BaseWars.Raid.HandleEntityDeath(ent)
end)

hook.Add("PlayerDisconnected", "BaseWars_RaidPlayerDisconnected", function(ply)
    local raid = BaseWars.Raid.CurrentRaid
    if not raid then return end

    if ply:GetFaction() == raid.Attacker then
        raid:AttackerKilled(ply:Nick())
    end
end)

concommand.Add("bw_test_start_raid", function(ply)
    if not ply:IsSuperAdmin() then return end

    local players = player.GetAll()
    local secondPlayer = players[2]
    if not IsValid(secondPlayer) then return end

    BaseWars.Faction.CreateFaction("MeMeMe", "", Color(255, 0, 0), "icon16/gun.png", ply)
    BaseWars.Faction.CreateFaction("YouYouYou", "", Color(0, 255, 0), "icon16/gun.png", secondPlayer)

    local status, message = BaseWars.Raid.StartRaid("MeMeMe", "YouYouYou")
    BaseWars.Notify.Send(ply, BaseWars.Lang("Raid"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)
