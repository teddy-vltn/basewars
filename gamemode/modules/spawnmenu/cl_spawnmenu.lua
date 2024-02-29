BaseWars = BaseWars or {}
BaseWars.SpawnMenu = BaseWars.SpawnMenu or {}

local Player = FindMetaTable("Player")

function Player:BuyEntity(uuid)
    local netTag = BaseWars.SpawnMenu.Net.BuyEntity

    BaseWars.Net.SendToServer(netTag, {uuid = uuid})
end

function Player:SetAutoBuy(bool, weapon)
    local netTag = BaseWars.SpawnMenu.Net.AutoBuy

    BaseWars.Log("Player " .. self:Nick() .. " (" .. self:SteamID() .. ") attempted to set auto buy to " .. tostring(bool) .. " for weapon " .. weapon .. ".")

    BaseWars.Net.SendToServer(netTag, {bool = bool, weapon = weapon})
end

function BaseWars.SpawnMenu.PopulateTree(tree, shopTable, callback)
    for categoryName, categoryOrItem in pairs(shopTable) do
        if type(categoryOrItem) == "table" then
            if not categoryOrItem.Price then  -- It's a category

                local tryTranslation = BaseWars.TryTranslate(categoryName)

                local categoryNode = tree:AddNode(tryTranslation)
                -- Put icon if it's a category
                categoryNode:SetIcon(categoryOrItem.Icon or "icon16/folder.png")
                BaseWars.SpawnMenu.PopulateTree(categoryNode, categoryOrItem, callback)
                categoryNode.DoClick = function()
                    callback(categoryOrItem, "")
                end

                -- set expanded
                categoryNode:SetExpanded(true)
            end
        end
    end
end