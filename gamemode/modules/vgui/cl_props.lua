function CreatePropsPanel(parent)
    -- TODO: Fix bug where when last tab name is saved the
    -- tree category gets fucked and becomes tiny in width for some reason
    local propsPanel = vgui.Create("DPanel", parent)
    propsPanel:Dock(FILL)

    local splitter = vgui.Create("DHorizontalDivider", propsPanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(200)

    local tree = vgui.Create("DTree", splitter)
    splitter:SetLeft(tree)

    local itemDisplay = vgui.Create("DPanel", splitter)
    splitter:SetRight(itemDisplay)

    local function displayPropsInCategory(props)
        itemDisplay:Clear()

        -- diconlayout
        local iconLayout = vgui.Create("DIconLayout", itemDisplay)
        iconLayout:Dock(FILL)
        iconLayout:SetSpaceX(5)
        iconLayout:SetSpaceY(5)
        
        for _, prop in pairs(props) do
            if prop.Name and prop.Price and prop.Model then
                local icon = iconLayout:Add("SpawnIcon")
                icon:SetModel(prop.Model)
                icon:SetToolTip(prop.Name .. " - " .. prop.Price .. "$")

                icon.DoClick = function()
                    -- standard sandbox spawn function
                    -- we use it for the props limit of sandbox to work properly
                    RunConsoleCommand("gm_spawn", prop.Model)

                end
            end
        end
    end

    for categoryName, props in pairs(BaseWars.Config.Props) do
        local categoryNode = tree:AddNode(categoryName, props.Icon)

        categoryNode.DoClick = function()
            displayPropsInCategory(props)
        end
    end
end
