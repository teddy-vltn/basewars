
function CreateBoutiquePanel(parent)

    PrintTable(BaseWars.Config.Shop)
    PrintTable(BaseWars.SpawnMenu.FlattenedShop)

    local boutiquePanel = vgui.Create("DPanel", parent)
    boutiquePanel:Dock(FILL)

    local searchBar = vgui.Create("DTextEntry", boutiquePanel)
    searchBar:Dock(TOP)
    searchBar:SetPlaceholderText("Search...")

    -- margin with the bottom elements
    searchBar:DockMargin(0, 0, 0, 5)

    searchBar.OnChange = function(self)
        local searchQuery = self:GetValue()
        displayItemsFiltered(BaseWars.Config.Shop, searchQuery)
    end

    local splitter = vgui.Create("DHorizontalDivider", boutiquePanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(200)

    local tree = vgui.Create("DTree", splitter)
    splitter:SetLeft(tree)

    local itemDisplay = vgui.Create("DPanel", splitter)
    splitter:SetRight(itemDisplay)

    function displayItemsFiltered(categoryTable, filter)
        itemDisplay:Clear()
        local itemList = vgui.Create("DIconLayout", itemDisplay)
        itemList:Dock(FILL)
        itemList:SetSpaceX(5)
        itemList:SetSpaceY(5)
    
        -- Now, we collect items from the clicked category
        local items = BaseWars.SpawnMenu.CollectItems(categoryTable, BaseWars.Config.MaxShopRecursiveDepth)

        local showedItems = 0
    
        for key, itemProps in pairs(items) do

            local Price = itemProps.Price
            local Model = itemProps.Model
            local Name = itemProps.Name
            local ClassName = itemProps.ClassName
            local Level = itemProps.Level or 0

            print(key)
            
            if filter != "" and not string.find(string.lower(Name), string.lower(filter)) then continue end

            showedItems = showedItems + 1

            if showedItems > 30 then break end

            local itemButton = itemList:Add("DButton")
            itemButton:SetSize(100, 100)
            itemButton:SetText("")
            itemButton.itemUUID = key 
    
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

            if Level != 0 then
                local itemLabelLevel = vgui.Create("DLabel", itemButton)
                itemLabelLevel:Dock(TOP)
                itemLabelLevel:SetText("Level " .. Level)
                itemLabelLevel:SetContentAlignment(5)
                itemLabelLevel:SetTextColor(Color(255, 255, 255))
                itemLabelLevel:SetExpensiveShadow(1, Color(0, 0, 0))
                itemLabelLevel.Think = function()
                    if LocalPlayer():GetLevel() >= Level then
                        itemLabelLevel:SetTextColor(Color(0, 255, 0))
                    else
                        itemLabelLevel:SetTextColor(Color(255, 0, 0))
                    end
                end
                itemLabelLevel.Paint = function(self, w, h)
                    return 
                end
            end
            -- draw the level at the top
            
            
    
            itemButton.DoClick = function(self)
                LocalPlayer():BuyEntity(self.itemUUID)
            end
        end
    end

    local function populateTree(parentNode, categoryTable)
        for categoryName, categoryOrItem in pairs(categoryTable) do
            if type(categoryOrItem) == "table" then
                if not categoryOrItem.Price then  -- It's a category
                    local categoryNode = parentNode:AddNode(categoryName)
                    -- Put icon if it's a category
                    categoryNode:SetIcon(categoryOrItem.Icon or "icon16/folder.png")
                    populateTree(categoryNode, categoryOrItem)
                    categoryNode.DoClick = function()
                        displayItemsFiltered(categoryOrItem, "")
                    end
                end
            end
        end
    end

    populateTree(tree, BaseWars.Config.Shop)
end
