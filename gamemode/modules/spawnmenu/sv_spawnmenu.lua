BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

util.AddNetworkString("BaseWars_BuyEntity")
local function SpawnEntity(ply, class, pos, ang)

    local entity = ents.Create(class)
    if not IsValid(entity) then return end

    if entity.InitializeModules then
        entity:InitializeModules()

        -- initialize upgrade module
        for _, module in pairs(entity.Modules) do
            if module.Initialize then
                module:Initialize(entity)
            end
        end
    end

    entity:SetPos(pos)
    entity:SetAngles(ang)
    entity:Spawn()

    return true, "Successfully spawned entity"
end

function BaseWars.SpawnMenu.BuyEntity(ply, class, pos, ang)
    PrintTable(BaseWars.SpawnMenu.FlattenedShop)
    local entityTable = BaseWars.SpawnMenu.FlattenedShop[class]

    if not entityTable then return false, "Entity does not exist" end

    local level = entityTable.Level
    if level and level > ply:GetLevel() then return false, "You do not have the required level to buy this entity" end

    local price = entityTable.Price
    if not ply:CanAfford(price) then return false, "You cannot afford this entity" end

    local status, message = SpawnEntity(ply, class, pos, ang)
    if not status then return status, message end

    ply:AddMoney(-price)

    return true, "Successfully bought entity"
end

function BaseWars.SpawnMenu.CalcPosAndAng(ply, ent)
    local pos = ply:GetEyeTrace().HitPos
    local ang = ply:GetAngles()

    pos.z = pos.z + 16

    return pos, ang
end

net.Receive("BaseWars_BuyEntity", function(len, ply)
    local class = net.ReadString()

    local pos, ang = BaseWars.SpawnMenu.CalcPosAndAng(ply, class)

    local status, message = BaseWars.SpawnMenu.BuyEntity(ply, class, pos, ang)

    BaseWars.Notify.Send(ply, "Acheter une entité", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)