BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Factions = BaseWars.Faction.Factions or {}

BaseWars.Faction.Net = BaseWars.Faction.Net or {
    Create = "BaseWars_CreateFaction",
    Join = "BaseWars_JoinFaction",
    Leave = "BaseWars_LeaveFaction",
    Delete = "BaseWars_DeleteFaction",
    Update = "BaseWars_UpdateFaction",
    UpdateAll = "BaseWars_UpdateFactions"
}

BaseWars.Net.Register(BaseWars.Faction.Net.Create, { name = "string", password = "string", color = "color", icon = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Join, { name = "string", password = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Leave, { name = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Delete, { name = "string" })
BaseWars.Net.Register(BaseWars.Faction.Net.Update, { name = "string", faction = "table" })
BaseWars.Net.Register(BaseWars.Faction.Net.UpdateAll, { factions = "table" })

Faction = {}
Faction.__index = Faction

function Faction.new(name, password, color, icon, leader)
    local self = setmetatable({}, Faction)

    self.Name = name
    self.Password = password
    self.Color = color
    self.Icon = icon
    self.Members = {
        [leader] = true
    }
    self.Leader = leader

    return self
end

function Faction.__eq(a, b)
    return a.Name == b.Name
end

function Faction.__tostring(self)
    return self.Name
end

function Faction:GetMembers()
    return self.Members
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
    return table.Count(self.Members)
end

local Player = FindMetaTable("Player")

function BaseWars.Faction.GetFactions()
    return BaseWars.Faction.Factions
end

function BaseWars.Faction.GetFaction(name)
    return BaseWars.Faction.Factions[name]
end

function BaseWars.Faction.GetFactionByMember(ply)
    for k, v in pairs(BaseWars.Faction.Factions) do
        if v.Members[ply] then
            return v
        end
    end
end

function Player:GetFaction()
    return self:GetNWString("Faction")
end

function Player:IsFriendlyEntity(ent)

    return false
end

function BaseWars.Faction.ValidateName(name)
    if not name or name == "" then
        return false, "Name cannot be empty."
    elseif #name < 3 then
        return false, "Name is too short. Minimum 3 characters."
    elseif #name > 32 then
        return false, "Name is too long. Maximum 32 characters."
    elseif not name:match("^[%w%sÀ-ÖØ-öø-ÿ]+$") then
        return false, "Name contains invalid characters."
    end
    return true
end

function BaseWars.Faction.ValidatePassword(password)
    if password and #password > 32 then
        return false, "Password is too long. Maximum 32 characters."
    end
    return true
end

function BaseWars.Faction.ValidateColor(color)
    if not color or color == Color(0, 0, 0) then
        return false, "Color cannot be empty."
    end
    return true
end

function BaseWars.Faction.ValidateIcon(icon)
    if not icon or icon == "" then
        return false, "Icon cannot be empty."
    end
    return true
end

function BaseWars.Faction.Exists(name)
    return BaseWars.Faction.Factions[name] ~= nil
end