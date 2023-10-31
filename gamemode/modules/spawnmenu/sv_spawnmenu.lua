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

    -- If the entity has modules to initialize, do so
    if entity.InitializeModules then
        entity:InitializeModules()

        -- Initialize each module associated with the entity
        for _, module in pairs(entity.Modules) do
            if module.Initialize then
                module:Initialize(entity)
            end
        end
    end

    -- Set the entity's position and angle
    entity:SetPos(pos)
    entity:SetAngles(ang)
    entity:Spawn()

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
    local status, message = SpawnEntity(ply, class, pos, ang)
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
