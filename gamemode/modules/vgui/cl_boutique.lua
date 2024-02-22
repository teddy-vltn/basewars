
local function AskForAutoBuy(uuid, callback)
    Derma_Query("Do you want to auto-buy this item on spawn?", "Auto-buy", 
        "Yes", 
        function()
            if callback then
                callback(true, uuid) -- Callback indicating they chose "Yes"
            end
        end,
        "No", 
        function() 
            if callback then
                callback(false, uuid) -- Callback indicating they chose "No"
            end
        end
    )
end


function CreateBoutiquePanel(parent)

    local boutiquePanel = vgui.Create("DPanel", parent)
    boutiquePanel:Dock(FILL)

    local searchBar = vgui.Create("DTextEntry", boutiquePanel)
    searchBar:Dock(TOP)
    searchBar:SetPlaceholderText("Search...")

    -- if we click on the search bar menu should remain focused even if we let go of the key
    searchBar.OnGetFocus = function(self)
        BaseWars.Config._MenuFocus = true
    end

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

    local boolAutoBuy, weaponAutoBuy = BaseWars.SpawnMenu.GetWeaponAutoBuy(LocalPlayer())


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
            local Weapon = itemProps.Weapon or false
            
            if filter != "" and not string.find(string.lower(Name), string.lower(filter)) then continue end

            local itemReasonBlocked = nil
            local color = Color(210, 210, 210)

            itemReasonBlocked, _color = LocalPlayer():GetBuyEntityBlockReason(key)

            if itemReasonBlocked then
                color = _color
            end

            showedItems = showedItems + 1

            if showedItems > 30 then break end

            local itemPanel = itemList:Add("DPanel")
            itemPanel:SetSize(100, 100)
            itemPanel.itemUUID = key 

            itemPanel.Paint = function(self, w, h)

                -- draw the background solid white 230
                surface.SetDrawColor(230, 230, 230, 255)
                surface.DrawRect(0, 0, w, h)

                -- draw outline 40
                surface.SetDrawColor(40, 40, 40, 255)
                surface.DrawOutlinedRect(0, 0, w, h)

                -- (‘vgui/gradient-u’) material 
                surface.SetDrawColor(Color(color.r, color.g, color.b, 140))
                surface.SetMaterial(Material("vgui/gradient-d"))
                surface.DrawTexturedRect(0, 0, w, h)

            end
    
            if Model then
                local itemModel = vgui.Create("DModelPanel", itemPanel)
                itemModel:Dock(FILL)

                itemModel:SetModel(Model)
                
                -- Rotate the model
                itemModel.Angles = Angle(0, 45, 0)
                
                -- Calculate the center and size of the model
                local mn, mx = itemModel.Entity:GetRenderBounds()
                local center = (mn + mx) / 2
                local size = mn:Distance(mx)
                
                -- Adjust the camera to focus on the model's center 
                -- and position it in front of the model based on the model's size
                itemModel:SetLookAt(center)
                itemModel:SetCamPos(center + Vector(-size, 0, 0))  -- Adjusted this line to position the camera in front
                itemModel:SetFOV(70)
                
                -- Set lighting
                itemModel:SetAmbientLight(Color(255, 255, 255))
                itemModel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))   
                             
            end
            
            -- draw the name and price at the bottom 
            -- first name most bottom
            -- everything is centered
            
            local itemLabelName = vgui.Create("DLabel", itemPanel)
            itemLabelName:Dock(BOTTOM)
            itemLabelName:SetText(Name)
            itemLabelName:SetContentAlignment(5)
            itemLabelName:SetExpensiveShadow(1, Color(0, 0, 0))
            itemLabelName:SetTextColor(Color(40, 40, 40))

            local itemLabelPrice = vgui.Create("DLabel", itemPanel)
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

            if itemReasonBlocked then
                local itemLabelBlocked = vgui.Create("DLabel", itemPanel)
                itemLabelBlocked:Dock(TOP)
                itemLabelBlocked:SetText(itemReasonBlocked)
                itemLabelBlocked:SetContentAlignment(5)
                itemLabelBlocked:SetTextColor(color or Color(255, 0, 0))
                itemLabelBlocked:SetExpensiveShadow(1, Color(0, 0, 0))
                itemLabelBlocked.Think = function()
                    if itemReasonBlocked then
                        itemLabelBlocked:SetVisible(true)
                    else
                        itemLabelBlocked:SetVisible(false)
                    end
                end
                itemLabelBlocked.Paint = function(self, w, h)
                    return 
                end
            end

            local itemButton = vgui.Create("DButton", itemPanel)
            itemButton:SetSize(100,100)
            itemButton:SetPos(0,0)
            itemButton.itemUUID = key

            itemButton:SetText("")

            itemButton.HasBeenHoveredDuringThink = false

            itemButton.Paint = function(self, w, h) 
                if self.HasBeenHoveredDuringThink then
                    surface.SetDrawColor(255, 255, 255, 20)
                    surface.DrawRect(0, 0, w, h)
                end
            end

            itemButton.Think = function(self)
                if LocalPlayer():GetMoney() >= Price then
                    self:SetAlpha(255)
                else
                    self:SetAlpha(100)
                end

                if self:IsHovered() and not self.HasBeenHoveredDuringThink then
                    -- little sound
                    surface.PlaySound(BaseWars.Config.Sounds.Hover)

                    self.HasBeenHoveredDuringThink = true
                elseif not self:IsHovered() and self.HasBeenHoveredDuringThink then
                    self.HasBeenHoveredDuringThink = false
                end
                
            end
            
            
            itemButton.DoClick = function(self)
                -- click sound 
                surface.PlaySound(BaseWars.Config.Sounds.Click)

                LocalPlayer():BuyEntity(self.itemUUID)
            end

            -- ability to right click to open a context menu
            -- like: make favorite

            itemButton.DoRightClick = function(self)
                local menu = vgui.Create("DMenu")
                menu:SetPos(gui.MousePos())
                menu:MakePopup()
                -- icon is a star
                local itemButtonFavorite = menu:AddOption("Favorite", function()
                    -- make favorite
                end)
                itemButtonFavorite:SetIcon("icon16/star.png")
            end

            -- if it's a weapon add a button to allow auto-purchase on spawn
            if Weapon then


                -- the button is just an icon16/accept.png on the top right
                -- the button is disabled if you can't afford it
                -- the button draws over the item 
                local itemButtonAutoBuy = vgui.Create("DImageButton", itemPanel)
                itemButtonAutoBuy:SetSize(16, 16)

                if key == weaponAutoBuy then
                    itemButtonAutoBuy:SetImage("icon16/cancel.png")
                else
                    itemButtonAutoBuy:SetImage("icon16/arrow_rotate_clockwise.png")
                end
                itemButtonAutoBuy:SetPos(84 - 5, 0 + 5)
                itemButtonAutoBuy:SetEnabled(LocalPlayer():GetMoney() >= Price)
                itemButtonAutoBuy.DoClick = function(self)
                    print(boolAutoBuy, weaponAutoBuy)

                    if boolAutoBuy and key != weaponAutoBuy then
                        return -- send notify
                    end

                    if key == weaponAutoBuy then
                        LocalPlayer():SetAutoBuy(false, "")

                        boolAutoBuy = false
                        weaponAutoBuy = ""

                        self:SetImage("icon16/arrow_rotate_clockwise.png")
                    else
                        AskForAutoBuy(key, function(didChooseYes, weaponUUID)
                            if didChooseYes then
                                LocalPlayer():SetAutoBuy(true, weaponUUID)

                                boolAutoBuy = true
                                weaponAutoBuy = weaponUUID

                                

                                self:SetImage("icon16/cancel.png")
                            else
                                -- Player chose "No"
                            end
                        end)
                    end
                end
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

                    -- set expanded
                    categoryNode:SetExpanded(true)
                end
            end
        end
    end

    populateTree(tree, BaseWars.Config.Shop)

end
