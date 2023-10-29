
function CreateBoutiquePanel(parent)
    local boutiquePanel = vgui.Create("DPanel", parent)
    boutiquePanel:Dock(FILL)

    local boutiqueTabs = vgui.Create("DPropertySheet", boutiquePanel)
    boutiqueTabs:Dock(FILL)

    for mainCategory, subCategories in pairs(BaseWars.Config.Shop) do
        local mainCategoryPanel = vgui.Create("DPanel", boutiqueTabs)
        local subCategoryTabs = vgui.Create("DPropertySheet", mainCategoryPanel)
        subCategoryTabs:Dock(FILL)

        for subCategory, items in pairs(subCategories) do
            local itemPanel = vgui.Create("DIconLayout", subCategoryTabs)
            itemPanel:Dock(FILL)
            itemPanel:SetSpaceX(5)
            itemPanel:SetSpaceY(5)

            for itemName, itemProps in pairs(items) do
                local itemButton = vgui.Create("DButton", itemPanel)
                itemButton.Paint = function(self, w, h)return end

                local Price = itemProps.Price
                local Model = itemProps.Model
                local ClassName = itemProps.ClassName

                local itemModel = vgui.Create("DModelPanel", itemButton)
                itemModel:Dock(FILL)
                itemModel:SetModel(Model)

                local itemLabel = vgui.Create("DLabel", itemButton)
                itemLabel:Dock(BOTTOM)
                itemLabel:SetText(itemName .. " - " .. Price .. "$")

                itemButton:SetText("")
                itemButton.DoClick = function()
                    -- buy feature
                end

                itemButton:SetSize(100, 100)

                itemPanel:Add(itemButton)
            end

            subCategoryTabs:AddSheet(subCategory, itemPanel)
        end

        boutiqueTabs:AddSheet(mainCategory, mainCategoryPanel)
    end
end
