function CreateToolsPanel(parent)
    local toolsPanel = vgui.Create("DPanel", parent)
    toolsPanel:Dock(FILL)

    local splitter = vgui.Create("DHorizontalDivider", toolsPanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(200)

    local leftPanel = vgui.Create("DPanel", splitter)
    splitter:SetLeft(leftPanel)

    local rightPanel = vgui.Create("DPanel", splitter)
    splitter:SetRight(rightPanel)

    local sheet = vgui.Create("DPropertySheet", leftPanel)
    sheet:Dock(FILL)

    for _, category in ipairs(spawnmenu.GetTools()) do
        local catPanel = vgui.Create("DScrollPanel")
        sheet:AddSheet(category.Label, catPanel, category.Icon)

        for _, toolSection in ipairs(category.Items) do
            for _, tool in ipairs(toolSection) do
                if tool.ItemName and tool.CPanelFunction then
                    local toolButton = vgui.Create("DButton", catPanel)
                    toolButton:SetText(tool.Text)
                    toolButton:Dock(TOP)
                    toolButton.DoClick = function()
                        rightPanel:Clear()
                        
                        -- create a scrollable controlpanel
                        local scrollPanel = vgui.Create("DScrollPanel", rightPanel)
                        scrollPanel:Dock(FILL)

                        -- create the controlpanel
                        local controlPanel = vgui.Create("ControlPanel", scrollPanel)
                        controlPanel:Dock(FILL)

                        -- add the tool to the controlpanel
                        tool.CPanelFunction(controlPanel)

                        -- activate the tool
                        spawnmenu.ActivateTool(tool.ItemName)
                    end
                end
            end
        end
    end

    return toolsPanel
end
