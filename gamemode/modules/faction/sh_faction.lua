BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

BaseWars.Faction.Net = BaseWars.Faction.Net or {
    Create = "BaseWars_CreateFaction",
    Join = "BaseWars_JoinFaction",
    Kick = "BaseWars_KickFaction",
    Leave = "BaseWars_LeaveFaction",
    Delete = "BaseWars_DeleteFaction",
    Update = "BaseWars_UpdateFaction",
    UpdateAll = "BaseWars_UpdateFactions",
    Invite = "BaseWars_InviteFaction",
    InviteReceived = "BaseWars_FactionInviteReceived",
    AcceptInvite = "BaseWars_AcceptFactionInvite",
    DeclineInvite = "BaseWars_DeclineFactionInvite"
}

BaseWars.Net.Register(BaseWars.Faction.Net.Create, { name = "string", password = "string", color = "color", icon = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Join, { name = "string", password = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Kick, { target = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Leave, { name = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Delete, { name = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Update, { name = "string", faction = "table" })
BaseWars.Net.Register(BaseWars.Faction.Net.UpdateAll, { factions = "table" })
BaseWars.Net.Register(BaseWars.Faction.Net.Invite, { target = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.InviteReceived, { faction = "string", leader = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.AcceptInvite, { faction = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.DeclineInvite, { faction = "string" })

Faction = {}
Faction.__index = Faction

local function PlayerSteamID(ply)
    if not IsValid(ply) or not ply:IsPlayer() or not ply.SteamID then return nil end
    return ply:SteamID()
end

local function IsPlayerValue(value)
    return IsValid(value) and value.IsPlayer and value:IsPlayer()
end

function Faction.new(name, password, color, icon, leader)
    local self = setmetatable({}, Faction)
    local leaderID = IsPlayerValue(leader) and PlayerSteamID(leader) or leader

    self.Name = name
    self.Password = password or ""
    self.Color = color
    self.Icon = icon
    self.Members = {}
    self.Leader = leaderID

    if leaderID then
        self.Members[leaderID] = {
            name = IsPlayerValue(leader) and leader:Nick() or tostring(leader),
            steamID = leaderID
        }
    end

    return self
end

function Faction.__eq(a, b)
    return a.Name == b.Name
end

function Faction.__tostring(self)
    return self.Name
end

function Faction:GetMembers()
    return self.Members or {}
end

function Faction:GetName()
    return self.Name
end

function Faction:HasPassword()
    return self.Password ~= ""
end

function Faction:GetPassword()
    return self.Password
end

function Faction:GetColor()
    return self.Color
end

function Faction:GetIcon()
    return self.Icon
end

function Faction:GetLeader()
    return self.Leader
end

function Faction:GetMemberCount()
    return table.Count(self.Members or {})
end

function Faction:IsMember(plyOrSteamID)
    local steamID = IsPlayerValue(plyOrSteamID) and PlayerSteamID(plyOrSteamID) or plyOrSteamID
    return steamID and self.Members and self.Members[steamID] ~= nil
end

function Faction:IsLeader(plyOrSteamID)
    local steamID = IsPlayerValue(plyOrSteamID) and PlayerSteamID(plyOrSteamID) or plyOrSteamID
    return steamID and self.Leader == steamID
end

local Player = FindMetaTable("Player")

function BaseWars.Faction.GetFactions()
    return BaseWars.Faction.Factions
end

function BaseWars.Faction.GetFaction(name)
    return BaseWars.Faction.Factions[name]
end

function BaseWars.Faction.GetFactionByMember(plyOrSteamID)
    local steamID = IsPlayerValue(plyOrSteamID) and PlayerSteamID(plyOrSteamID) or plyOrSteamID
    if not steamID then return end

    for _, faction in pairs(BaseWars.Faction.Factions) do
        if faction:IsMember(steamID) then
            return faction
        end
    end
end

function BaseWars.Faction.GetOnlinePlayerBySteamID(steamID)
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == steamID then
            return ply
        end
    end
end

function BaseWars.Faction.GetOnlineMembers(faction)
    local members = {}
    if not faction then return members end

    for steamID in pairs(faction:GetMembers()) do
        local ply = BaseWars.Faction.GetOnlinePlayerBySteamID(steamID)
        if IsValid(ply) then
            table.insert(members, ply)
        end
    end

    return members
end

function Player:GetFaction()
    return self:GetNWString("Faction")
end

function Player:IsFriendlyEntity(ent)
    if not IsValid(ent) or not ent.CPPIGetOwner then return false end

    local owner = ent:CPPIGetOwner()
    if not IsValid(owner) then return false end

    local faction = BaseWars.Faction.GetFactionByMember(self)
    return faction and faction:IsMember(owner)
end

function BaseWars.Faction.ValidateName(name)
    if not name or name == "" then
        return false, BaseWars.Lang("NameCannotBeEmpty")
    elseif #name < 3 then
        return false, BaseWars.Lang("NameIsTooShort")
    elseif #name > 32 then
        return false, BaseWars.Lang("NameIsTooLong")
    elseif not name:match("^[%w%sÀ-ÖØ-öø-ÿ]+$") then
        return false, BaseWars.Lang("NameContainsInvalidCharacters")
    end
    return true
end

function BaseWars.Faction.ValidatePassword(password)
    if password and #password > 32 then
        return false, BaseWars.Lang("PasswordIsTooLong")
    end
    return true
end

function BaseWars.Faction.ValidateColor(color)
    if not color or color == Color(0, 0, 0) then
        return false, BaseWars.Lang("ColorCannotBeEmpty")
    end
    return true
end

function BaseWars.Faction.ValidateIcon(icon)
    if not icon or icon == "" then
        return false, BaseWars.Lang("IconCannotBeEmpty")
    end
    return true
end

function BaseWars.Faction.Exists(name)
    return BaseWars.Faction.Factions[name] ~= nil
end
