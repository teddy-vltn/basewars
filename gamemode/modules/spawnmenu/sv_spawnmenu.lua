-- Ensure the BaseWars table exists or initialize it
BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

local Player = FindMetaTable("Player")

function Player:AddToEntityCount(class, amount)
    local key = string.format(BaseWars.SpawnMenu.EntityCountFormat, class)
    local count = self:GetNWInt(key)
    self:SetNWInt(key, count + amount)
end

function Player:CheckEntityLimit(class, limit)

    -- Get the current count of the entity
    local count = self:GetEntityCount(class)

    -- Check if the player has reached the limit
    if count >= limit then return false, "You have reached the limit for this entity" end

    return true, "Successfully checked entity limit"
end

-- Function to spawn an entity based on its class, position, and angle.
-- Returns a status and a message indicating success or the reason for failure.
local function SpawnEntity(ply, class, pos, ang, value)

    -- Create the entity based on its class
    local entity = ents.Create(class)
    
    -- Check if the entity is valid, if not return an error
    if not IsValid(entity) then return false, "The entity doesn't exist?????" end

    -- Set the entity's position and angle
    entity:SetPos(pos)
    entity:SetAngles(ang)
    entity:Spawn()

    -- Set the entity's owner to the player
    entity:CPPISetOwner(ply)

    if value && entity.GetValue then
        value = value or 1
        entity:SetValue(value * BaseWars.Config.Globals.PercentageOfMoneyLostOnSell)
    end

    -- Add the entity to the player's count
    ply:AddToEntityCount(class, 1)

    return true, "Successfully spawned entity"
end

local function GiveWeapon(ply, class)
    -- Create the entity based on its class
    local entity = ents.Create(class)
    
    -- Check if the entity is valid, if not return an error
    if not IsValid(entity) then return false, "The entity doesn't exist?????" end

    -- Give the weapon to the player
    ply:Give(class)

    -- Equip the weapon
    ply:SelectWeapon(class)

    -- Give ammo to the player
    local ammoType = entity:GetPrimaryAmmoType()
    local ammoCount = entity:GetMaxClip1() * 2
    ply:SetAmmo(ammoCount, ammoType)

    return true, "Successfully spawned entity"
end

/*
    @description
    Attempts to buy an entity for the player.

    @param {Player} ply - The player entity to buy the entity for.
    @param {string} uuid - The UUID of the entity to buy.
    @param {Vector} pos - The position to spawn the entity at.
    @param {Angle} ang - The angle to spawn the entity at.

    @return {boolean, string} A status indicating success or failure, and a message explaining the result.
*/
function BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)
    -- Fetch the entity details from the flattened shop using the UUID
    local entityTable = BaseWars.SpawnMenu.FlattenedShop[uuid]
    
    -- If the entity doesn't exist in the shop, return an error
    if not entityTable then return false, "Entity does not exist" end

    -- Check Limit
    local limit = entityTable.Limit
    if limit then
        local status, message = ply:CheckEntityLimit(entityTable.ClassName, limit)
        if not status then return status, message end
    end

    -- Check if the player has the required level to buy the entity
    local level = entityTable.Level
    if level and level > ply:GetLevel() then return false, "You do not have the required level to buy this entity" end

    -- Check if the player can afford the entity
    local price = entityTable.Price
    if not ply:CanAfford(price) then return false, "You cannot afford this entity" end

    -- Attempt to spawn the entity
    local class = entityTable.ClassName
    local weapon = entityTable.Weapon

    local status, message

    if weapon then
        status, message = GiveWeapon(ply, class)
    else
        status, message = SpawnEntity(ply, class, pos, ang, price)
    end

    if not status then return status, message end

    -- Deduct the price of the entity from the player's money
    ply:AddMoney(-price)

    return true, "Successfully bought entity"
end

/*
    @description
    Calculates the position and angle to spawn an entity at based on the player's current view.

    @param {Player} ply - The player entity to calculate the position and angle for.
    @param {string} uuid - The UUID of the entity to calculate the position and angle for.

    @return {Vector, Angle} The position and angle to spawn the entity at.
*/
function BaseWars.SpawnMenu.CalcPosAndAng(ply, ent)
    -- Get the position where the player is looking
    local pos = ply:GetEyeTrace().HitPos
    -- Get the player's current angles (direction they're facing)
    local ang = ply:GetAngles()

    -- Adjust the spawn position slightly above the ground to prevent clipping
    pos.z = pos.z + 16

    return pos, ang
end

-- Network handler for buying an entity.
-- Listens for a request from the client, processes the buying logic, and sends a notification back to the client.
local netBuyTag = BaseWars.SpawnMenu.Net.BuyEntity
net.Receive(netBuyTag, function(len, ply)
    local data = BaseWars.Net.Read(netBuyTag)

    local uuid = data.uuid

    -- Calculate the spawn position and angle based on the player's current view
    local pos, ang = BaseWars.SpawnMenu.CalcPosAndAng(ply, uuid)

    -- Try to buy the entity
    local status, message = BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)

    -- Print debug information to the server console
    BaseWars.Log("Player " .. ply:Nick() .. " (" .. ply:SteamID() .. ") attempted to buy entity " .. uuid .. " (" .. (status and "success" or "failure") .. ")")

    -- Send a notification to the player about the result of their purchase request
    BaseWars.Notify.Send(ply, "Acheter une entité", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

-- NWBool to store whether the player has auto buy enabled
local AUTOBUY_WEAPON = "BaseWars_AutoBuyWeapon"
local AUTOBUY_BOOL = "BaseWars_AutoBuyBool"

local netAutoBuyTag = BaseWars.SpawnMenu.Net.AutoBuy

-- Cette fonction semble redondante, donc nous la supprimons
-- function BaseWars.SpawnMenu.SetWeaponForAutoBuy(ply, uuid) ...
function BaseWars.SpawnMenu.DisableWeaponAutoBuy(ply)
    ply:SetNWBool(AUTOBUY_BOOL, false)
    ply:SetNWString(AUTOBUY_WEAPON, "")

    return true, "Successfully disabled auto buy for all weapons."
end

function BaseWars.SpawnMenu.ActivateWeaponAutoBuy(ply, uuid, state)
    ply:SetNWBool(AUTOBUY_BOOL, state)

    if state then
        ply:SetNWString(AUTOBUY_WEAPON, uuid)
        return true, "Successfully enabled auto buy for weapon " .. uuid
    else
        ply:SetNWString(AUTOBUY_WEAPON, "")
        return true, "Successfully disabled auto buy for weapon " .. uuid
    end
end

net.Receive(netAutoBuyTag, function(len, ply)

    local data = BaseWars.Net.Read(netAutoBuyTag)

    local uuid = data.weapon
    local state = data.bool

    print(uuid, state)

    local status, message
    if state then
        status, message = BaseWars.SpawnMenu.ActivateWeaponAutoBuy(ply, uuid, state)

        BaseWars.SpawnMenu.BuyEntity(ply, uuid, nil, nil)
    else
        status, message = BaseWars.SpawnMenu.DisableWeaponAutoBuy(ply)
    end

    BaseWars.Notify.Send(ply, "Auto Buy", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

hook.Add("PlayerSpawn", "BaseWars_AutoBuyHook", function(ply)
    -- call it on the next frame because gmod is dumb
    timer.Simple(0, function()
        if not IsValid(ply) then return end  -- Check if the player is still valid
        
        if ply:GetNWBool(AUTOBUY_BOOL) then
            local uuid = ply:GetNWString(AUTOBUY_WEAPON)
            if uuid and uuid ~= "" then
                BaseWars.SpawnMenu.BuyEntity(ply, uuid)
            end
        end
    end)
end)

