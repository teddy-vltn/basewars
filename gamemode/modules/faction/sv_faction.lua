BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.PendingInvites = BaseWars.Faction.PendingInvites or {}

local Player = FindMetaTable("Player")
local INVITE_EXPIRE_TIME = 60

local function SteamIDOf(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return nil end
    return ply:SteamID()
end

local function PlayerName(ply)
    return IsValid(ply) and (ply:Nick() or ply:Name()) or "Unknown"
end

function Faction:SetLeader(leader)
    local steamID = type(leader) == "string" and leader or SteamIDOf(leader)
    if not steamID then return end
    self.Leader = steamID
end

function Player:SetFaction(faction)
    local factionName = type(faction) == "table" and faction:GetName() or faction
    self:SetNWString("Faction", factionName or "")
end

local function AddMember(faction, ply)
    local steamID = SteamIDOf(ply)
    if not steamID then return false end

    faction.Members[steamID] = {
        steamID = steamID,
        name = PlayerName(ply)
    }
    ply:SetFaction(faction)

    return true
end

local function RemoveMember(faction, steamID)
    faction.Members[steamID] = nil
end

local function ClearInvite(steamID, factionName)
    if not BaseWars.Faction.PendingInvites[steamID] then return end
    BaseWars.Faction.PendingInvites[steamID][factionName] = nil

    if table.Count(BaseWars.Faction.PendingInvites[steamID]) == 0 then
        BaseWars.Faction.PendingInvites[steamID] = nil
    end
end

local function ClearFactionInvites(factionName)
    for steamID, invites in pairs(BaseWars.Faction.PendingInvites) do
        invites[factionName] = nil
        if table.Count(invites) == 0 then
            BaseWars.Faction.PendingInvites[steamID] = nil
        end
    end
end

function BaseWars.Faction.Initialize()
    BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}
    BaseWars.Faction.SyncFactions()
end

local function ValidateFaction(name, password, color, icon)
    local validName, nameErr = BaseWars.Faction.ValidateName(name)
    if not validName then return false, nameErr end

    local validPassword, passwordErr = BaseWars.Faction.ValidatePassword(password)
    if not validPassword then return false, passwordErr end

    local validColor, colorErr = BaseWars.Faction.ValidateColor(color)
    if not validColor then return false, colorErr end

    local validIcon, iconErr = BaseWars.Faction.ValidateIcon(icon)
    if not validIcon then return false, iconErr end

    return true
end

local function copyFactionForClientSend(faction)
    if not faction then return end

    local members = {}
    for steamID, memberData in pairs(faction:GetMembers()) do
        local ply = BaseWars.Faction.GetOnlinePlayerBySteamID(steamID)
        members[steamID] = {
            steamID = steamID,
            name = IsValid(ply) and PlayerName(ply) or (memberData.name or steamID),
            online = IsValid(ply)
        }
    end

    local leader = BaseWars.Faction.GetOnlinePlayerBySteamID(faction:GetLeader())

    return {
        Name = faction:GetName(),
        Members = members,
        Password = faction:HasPassword(),
        Color = faction:GetColor(),
        Icon = faction:GetIcon(),
        Leader = faction:GetLeader(),
        LeaderName = IsValid(leader) and PlayerName(leader) or (members[faction:GetLeader()] and members[faction:GetLeader()].name or faction:GetLeader())
    }
end

function BaseWars.Faction.SyncFactions(ply)
    local factions = {}
    for name, faction in pairs(BaseWars.Faction.Factions) do
        factions[name] = copyFactionForClientSend(faction)
    end

    if IsValid(ply) then
        BaseWars.Net.SendToPlayer(ply, BaseWars.Faction.Net.UpdateAll, { factions = factions })
    else
        BaseWars.Net.Broadcast(BaseWars.Faction.Net.UpdateAll, { factions = factions })
    end
end

function BaseWars.Faction.SyncFaction(factionName, faction)
    faction = faction or BaseWars.Faction.Factions[factionName]
    if not faction then return end

    BaseWars.Net.Broadcast(BaseWars.Faction.Net.Update, {
        name = faction:GetName(),
        faction = copyFactionForClientSend(faction)
    })
end

function BaseWars.Faction.CreateFaction(name, password, color, icon, leader)
    if not IsValid(leader) then return false, BaseWars.Lang("InvalidPlayer") end
    if BaseWars.Faction.Exists(name) then return false, BaseWars.Lang("FactionAlreadyExists", name) end
    if BaseWars.Faction.GetFactionByMember(leader) then return false, BaseWars.Lang("FactionAlreadyMember") end

    local valid, err = ValidateFaction(name, password, color, icon)
    if not valid then return false, err end

    local faction = Faction.new(name, password, color, icon, leader)
    BaseWars.Faction.Factions[name] = faction
    AddMember(faction, leader)
    BaseWars.Faction.SyncFaction(name, faction)

    return true, BaseWars.Lang("CreatedFaction", name)
end

net.Receive(BaseWars.Faction.Net.Create, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.Create)
    local status, message = BaseWars.Faction.CreateFaction(data.name, data.password, data.color, data.icon, ply)

    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionCreate"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

function BaseWars.Faction.InvitePlayer(leader, target)
    if type(target) == "string" then
        target = BaseWars.Faction.GetOnlinePlayerBySteamID(target) or BaseWars.FindPlayerByName(target)
    end

    if not IsValid(target) or not target:IsPlayer() then return false, BaseWars.Lang("InvalidPlayer") end
    if target == leader then return false, BaseWars.Lang("FactionCantJoin", PlayerName(target)) end

    local faction = BaseWars.Faction.GetFactionByMember(leader)
    if not faction then return false, BaseWars.Lang("NotInFaction") end
    if not faction:IsLeader(leader) then return false, BaseWars.Lang("FactionNotOwner") end
    if BaseWars.Faction.GetFactionByMember(target) then return false, BaseWars.Lang("FactionAlreadyMember") end

    local targetID = SteamIDOf(target)
    BaseWars.Faction.PendingInvites[targetID] = BaseWars.Faction.PendingInvites[targetID] or {}
    BaseWars.Faction.PendingInvites[targetID][faction:GetName()] = {
        leader = SteamIDOf(leader),
        expires = CurTime() + INVITE_EXPIRE_TIME
    }

    timer.Create("BaseWars_FactionInvite_" .. targetID .. "_" .. faction:GetName(), INVITE_EXPIRE_TIME, 1, function()
        ClearInvite(targetID, faction:GetName())
    end)

    BaseWars.Net.SendToPlayer(target, BaseWars.Faction.Net.InviteReceived, {
        faction = faction:GetName(),
        leader = PlayerName(leader)
    })

    return true, BaseWars.Lang("FactionInviteSent", PlayerName(target))
end

net.Receive(BaseWars.Faction.Net.Invite, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.Invite)
    local status, message = BaseWars.Faction.InvitePlayer(ply, data.target)

    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionInvite"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

function BaseWars.Faction.AcceptInvite(ply, factionName)
    local steamID = SteamIDOf(ply)
    local invite = steamID and BaseWars.Faction.PendingInvites[steamID] and BaseWars.Faction.PendingInvites[steamID][factionName]
    if not invite then return false, BaseWars.Lang("FactionInviteMissing") end

    local faction = BaseWars.Faction.GetFaction(factionName)
    if not faction then
        ClearInvite(steamID, factionName)
        return false, BaseWars.Lang("FactionDoesntExist", factionName)
    end

    if invite.expires <= CurTime() then
        ClearInvite(steamID, factionName)
        return false, BaseWars.Lang("FactionInviteExpired")
    end

    if BaseWars.Faction.GetFactionByMember(ply) then return false, BaseWars.Lang("FactionAlreadyMember") end

    ClearInvite(steamID, factionName)
    AddMember(faction, ply)
    BaseWars.Faction.SyncFaction(factionName, faction)

    return true, BaseWars.Lang("JoinedFaction", factionName)
end

net.Receive(BaseWars.Faction.Net.AcceptInvite, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.AcceptInvite)
    local status, message = BaseWars.Faction.AcceptInvite(ply, data.faction)

    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionJoin"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

net.Receive(BaseWars.Faction.Net.DeclineInvite, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.DeclineInvite)
    ClearInvite(SteamIDOf(ply), data.faction)
    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionInvite"), BaseWars.Lang("FactionInviteDeclined", data.faction), Color(255, 255, 255))
end)

function BaseWars.Faction.JoinFaction(ply, factionName)
    return BaseWars.Faction.AcceptInvite(ply, factionName)
end

net.Receive(BaseWars.Faction.Net.Join, function(len, ply)
    BaseWars.Net.Read(BaseWars.Faction.Net.Join)
    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionJoin"), BaseWars.Lang("FactionInviteRequired"), Color(255, 0, 0))
end)

function BaseWars.Faction.LeaveFaction(ply)
    local faction = BaseWars.Faction.GetFactionByMember(ply)
    if not faction then return false, BaseWars.Lang("NotInFaction") end

    local steamID = SteamIDOf(ply)
    local name = faction:GetName()

    RemoveMember(faction, steamID)
    ply:SetFaction("")

    if faction:GetMemberCount() == 0 then
        BaseWars.Faction.DeleteFaction(name)
    else
        if faction:GetLeader() == steamID then
            faction:SetLeader(next(faction.Members))
            ClearFactionInvites(name)
        end

        BaseWars.Faction.SyncFaction(name, faction)
    end

    return true, BaseWars.Lang("FactionLeft", name)
end

function BaseWars.Faction.DeleteFaction(name)
    local faction = BaseWars.Faction.GetFaction(name)
    if not faction then return false, BaseWars.Lang("FactionDoesntExist", name) end

    for steamID in pairs(faction:GetMembers()) do
        local ply = BaseWars.Faction.GetOnlinePlayerBySteamID(steamID)
        if IsValid(ply) then
            ply:SetFaction("")
        end
    end

    ClearFactionInvites(name)
    BaseWars.Faction.Factions[name] = nil

    BaseWars.Net.Broadcast(BaseWars.Faction.Net.Delete, { name = name })
    return true, BaseWars.Lang("FactionDeleted", name)
end

net.Receive(BaseWars.Faction.Net.Leave, function(len, ply)
    BaseWars.Net.Read(BaseWars.Faction.Net.Leave)
    local status, message = BaseWars.Faction.LeaveFaction(ply)

    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionLeave"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

function BaseWars.Faction.SetFaction(ply, name, leader)
    if not IsValid(ply) then return false, BaseWars.Lang("InvalidPlayer") end

    local faction = BaseWars.Faction.GetFaction(name)
    if not faction then return false, BaseWars.Lang("FactionDoesntExist", name) end

    AddMember(faction, ply)
    if leader then
        faction:SetLeader(ply)
        ClearFactionInvites(name)
    end

    BaseWars.Faction.SyncFaction(name, faction)
    return true
end

function BaseWars.Faction.KickPlayer(ply, target)
    local targetID = nil
    local targetName = tostring(target)

    if type(target) == "string" then
        targetID = target
        target = BaseWars.Faction.GetOnlinePlayerBySteamID(target) or BaseWars.FindPlayerByName(target)
    end

    local faction = BaseWars.Faction.GetFactionByMember(ply)
    if not faction then return false, BaseWars.Lang("NotInFaction") end
    if not faction:IsLeader(ply) then return false, BaseWars.Lang("FactionNotOwner") end

    if IsValid(target) then
        targetID = SteamIDOf(target)
        targetName = PlayerName(target)
    end

    if not targetID then return false, BaseWars.Lang("InvalidPlayer") end
    if faction:GetLeader() == targetID then return false, BaseWars.Lang("FactionCannotKickOwner") end
    if not faction:IsMember(targetID) then return false, BaseWars.Lang("FactionPlayerNotMemberOfThisFaction", targetName) end

    RemoveMember(faction, targetID)
    if IsValid(target) then
        target:SetFaction("")
        BaseWars.Notify.Send(target, BaseWars.Lang("FactionKick"), BaseWars.Lang("FactionKicked", faction:GetName()), Color(255, 0, 0))
    end

    BaseWars.Faction.SyncFaction(faction:GetName(), faction)

    return true, BaseWars.Lang("FactionKickedPlayer", targetName)
end

net.Receive(BaseWars.Faction.Net.Kick, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Faction.Net.Kick)
    local status, message = BaseWars.Faction.KickPlayer(ply, data.target)

    BaseWars.Notify.Send(ply, BaseWars.Lang("FactionKick"), message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

hook.Add("PlayerInitialSpawn", "BaseWars_FactionSync", function(ply)
    for _, faction in pairs(BaseWars.Faction.Factions) do
        local member = faction.Members[SteamIDOf(ply)]
        if member then
            member.name = PlayerName(ply)
            ply:SetFaction(faction)
        end
    end

    BaseWars.Faction.SyncFactions(ply)
    BaseWars.Faction.SyncFactions()
end)
