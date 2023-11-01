-- Ensure the BaseWars table exists or initialize it
BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

-- Register a network string for entity purchasing
util.AddNetworkString("BaseWars_BuyEntity")

-- Function to spawn an entity based on its class, position, and angle.
-- Returns a status and a message indicating success or the reason for failure.
local function SpawnEntity(ply, class, pos, ang)
    -- Create the entity based on its class
    local entity = ents.Create(class)
    
    -- Check if the entity is valid, if not return an error
    if not IsValid(entity) then return false, "The entity doesn't exist?????" end

    -- Set the entity's position and angle
    entity:SetPos(pos)
    entity:SetAngles(ang)
    entity:Spawn()

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

-- Function to handle the purchasing of an entity.
-- Checks various conditions (e.g., player level, affordability) before spawning the entity.
function BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)
    -- Fetch the entity details from the flattened shop using the UUID
    local entityTable = BaseWars.SpawnMenu.FlattenedShop[uuid]
    
    -- If the entity doesn't exist in the shop, return an error
    if not entityTable then return false, "Entity does not exist" end

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
        status, message = SpawnEntity(ply, class, pos, ang)
    end

    if not status then return status, message end

    -- Deduct the price of the entity from the player's money
    ply:AddMoney(-price)

    return true, "Successfully bought entity"
end

-- Function to calculate the position and angle where an entity should be spawned relative to the player.
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
net.Receive("BaseWars_BuyEntity", function(len, ply)
    local uuid = net.ReadString()

    -- Calculate the spawn position and angle based on the player's current view
    local pos, ang = BaseWars.SpawnMenu.CalcPosAndAng(ply, uuid)

    -- Try to buy the entity
    local status, message = BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)

    -- Print debug information to the server console
    print("UUID:", uuid)
    print("Status:", status)
    print("Message:", message)

    -- Send a notification to the player about the result of their purchase request
    BaseWars.Notify.Send(ply, "Acheter une entité", message, status and Color(0, 255, 0) or Color(255, 0, 0))
end)

local AUTOBUY_BOOL = "BaseWars_AutoBuy"
local AUTOBUY_WEAPON = "BaseWars_AutoBuyWeapon"

util.AddNetworkString(AUTOBUY_BOOL)

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

net.Receive(AUTOBUY_BOOL, function(len, ply)
    local state = net.ReadBool()
    local uuid = net.ReadString()

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

