
function CreateBoutiquePanel(parent)
    local boutiquePanel = vgui.Create("DPanel", parent)
    boutiquePanel:Dock(FILL)

    local splitter = vgui.Create("DHorizontalDivider", boutiquePanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(200)

    local tree = vgui.Create("DTree", splitter)
    splitter:SetLeft(tree)

    local itemDisplay = vgui.Create("DPanel", splitter)
    splitter:SetRight(itemDisplay)

    local function collectItems(categoryTable, depth)
        -- If the depth is zero or negative, stop the recursion.
        if depth <= 0 then return {} end
    
        local items = {}
    
        for _, categoryOrItem in pairs(categoryTable) do
            if categoryOrItem.Price then
                table.insert(items, categoryOrItem)
            else
                local subItems = collectItems(categoryOrItem, depth - 1)  -- Decrement the depth
                for _, item in ipairs(subItems) do
                    table.insert(items, item)
                end
            end
        end
    
        return items
    end
    

    local function displayItems(categoryTable)
        itemDisplay:Clear()
        local itemList = vgui.Create("DIconLayout", itemDisplay)
        itemList:Dock(FILL)
        itemList:SetSpaceX(5)
        itemList:SetSpaceY(5)
    
        -- Now, we collect items from the clicked category
        local items = collectItems(categoryTable, BaseWars.Config.MaxShopRecursiveDepth)
    
        for itemName, itemProps in pairs(items) do
            local itemButton = itemList:Add("DButton")
            itemButton:SetSize(100, 100)
            itemButton:SetText("")
    
            local Price = itemProps.Price
            local Model = itemProps.Model
            local Name = itemProps.Name
    
            if Model then
                local itemModel = vgui.Create("DModelPanel", itemButton)
                itemModel:Dock(FILL)
                itemModel:SetModel(Model)

                -- Rotate the model
                itemModel.Angles = Angle(0, 45, 0)
                itemModel:SetLookAt(Vector(0, 0, 0))
                itemModel:SetCamPos(Vector(100, 100, 100))
                itemModel:SetFOV(10)
                itemModel:SetAmbientLight(Color(255, 255, 255))
                itemModel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))

            end
            
            -- draw the name and price at the bottom 
            -- first name most bottom
            -- everything is centered
            
            local itemLabelName = vgui.Create("DLabel", itemButton)
            itemLabelName:Dock(BOTTOM)
            itemLabelName:SetText(Name)
            itemLabelName:SetContentAlignment(5)
            itemLabelName:SetExpensiveShadow(1, Color(0, 0, 0))
            itemLabelName:SetTextColor(Color(40, 40, 40))

            local itemLabelPrice = vgui.Create("DLabel", itemButton)
            itemLabelPrice:Dock(BOTTOM)
            itemLabelPrice:SetText("$" .. Price)
            itemLabelPrice:SetContentAlignment(5)
            -- draw color is green if you can buy it, red if you can't
            itemLabelPrice:SetTextColor(Color(255, 0, 0))
            itemLabelPrice:SetExpensiveShadow(1, Color(0, 0, 0))
            itemLabelPrice.Think = function()
                if LocalPlayer():GetMoney() >= Price then
                    itemLabelPrice:SetTextColor(Color(0, 255, 0))
                else
                    itemLabelPrice:SetTextColor(Color(255, 0, 0))
                end
            end
            
    
            itemButton.DoClick = function()
                -- buy feature
            end
        end
    end

    local function populateTree(parentNode, categoryTable)
        for categoryName, categoryOrItem in pairs(categoryTable) do
            if not categoryOrItem.Price then  -- It's a category
                local categoryNode = parentNode:AddNode(categoryName)
                populateTree(categoryNode, categoryOrItem)
                categoryNode.DoClick = function()
                    displayItems(categoryOrItem)
                end
            end
        end
    end

    populateTree(tree, BaseWars.Config.Shop)
end
