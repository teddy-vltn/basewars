BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

BaseWars.SpawnMenu.FlattenedShop = BaseWars.SpawnMenu.FlattenedShop or {}

local function stringHash(input)
    local hash = 0
    local len = #input

    for i = 1, len do
        local char = string.byte(input, i)
        hash = (hash * 31 + char) % 0xFFFFFFFF
    end

    return hash
end

-- A deterministic version of your UUID generation function
function BaseWars.SpawnMenu.GenerateUUID(item)
    -- Convert item properties to a string
    local itemStr = item.Name .. item.Price .. item.Model .. item.ClassName

    -- Compute a hash from the string
    local seed = stringHash(itemStr)
    
    -- A simple seeded pseudo-random number generator
    local function seededRandom()
        seed = (seed * 1103515245 + 12345) % 0x10000
        return (bit.band(seed, 0x7FFF)) / 0x7FFF  -- normalize to [0, 1)
    end

    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local r = seededRandom()
        if c == 'x' then
            return string.format('%x', math.floor(r * 16))
        else
            return string.format('%x', 8 + math.floor(r * 4))
        end
    end)
end

-- Recursive function to traverse and add UUIDs as keys
function BaseWars.SpawnMenu.AddUUIDsToShop(categoryTable)
    local newTable = {}

    for key, value in pairs(categoryTable) do
        -- If the value has a ClassName, then it's an item
        if value.ClassName then
            local UUID = BaseWars.SpawnMenu.GenerateUUID(value)
            print("Adding UUID " .. UUID .. " to " .. value.ClassName)
            newTable[UUID] = value
        elseif type(value) == "table" and not value.ClassName then
            -- It's a category or subcategory
            newTable[key] = BaseWars.SpawnMenu.AddUUIDsToShop(value)  -- Recurse
        else
            -- Just copy the value as-is (like the Icon key)
            newTable[key] = value
        end
    end
    
    return newTable
end

-- Add UUIDs to the shop
BaseWars.Config.Shop = BaseWars.SpawnMenu.AddUUIDsToShop(BaseWars.Config.Shop)

function BaseWars.SpawnMenu.CollectItems(categoryTable, depth)
    -- If the depth is zero or negative, stop the recursion.
    if depth <= 0 then return {} end

    local items = {}

    for key, categoryOrItem in pairs(categoryTable) do
        if type(categoryOrItem) ~= "table" then continue end
        
        if categoryOrItem.Price then
            items[key] = categoryOrItem
        else
            local subItems = BaseWars.SpawnMenu.CollectItems(categoryOrItem, depth - 1)  -- Decrement the depth
            for subKey, item in pairs(subItems) do
                items[subKey] = item
            end
        end
    end

    return items
end

function BaseWars.FlattenShop()
    local items = BaseWars.SpawnMenu.CollectItems(BaseWars.Config.Shop, 10) -- 10 est juste un nombre arbitrairement grand pour s'assurer que nous parcourons toute la profondeur
    BaseWars.SpawnMenu.FlattenedShop = items
end

BaseWars.FlattenShop()
