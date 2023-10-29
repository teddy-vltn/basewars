BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

BaseWars.SpawnMenu.FlattenedShop = BaseWars.SpawnMenu.FlattenedShop or {}

function BaseWars.SpawnMenu.CollectItems(categoryTable, depth)
    -- If the depth is zero or negative, stop the recursion.
    if depth <= 0 then return {} end

    local items = {}

    for _, categoryOrItem in pairs(categoryTable) do
        if type(categoryOrItem) ~= "table" then continue end
        
        if categoryOrItem.Price then
            table.insert(items, categoryOrItem)
        else
            local subItems = BaseWars.SpawnMenu.CollectItems(categoryOrItem, depth - 1)  -- Decrement the depth
            for _, item in ipairs(subItems) do
                table.insert(items, item)
            end
        end
    end

    return items
end

function BaseWars.FlattenShop()
    local items = BaseWars.SpawnMenu.CollectItems(BaseWars.Config.Shop, 10) -- 10 est juste un nombre arbitrairement grand pour s'assurer que nous parcourons toute la profondeur
    for _, item in ipairs(items) do
        BaseWars.SpawnMenu.FlattenedShop[item.ClassName] = item
    end
end

BaseWars.FlattenShop()

