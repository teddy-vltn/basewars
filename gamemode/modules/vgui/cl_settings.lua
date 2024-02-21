function CreateSettingsPanel(parent)
    local settingsPanel = vgui.Create("DPanel", parent)
    settingsPanel:Dock(FILL)

    local settingsScroll = vgui.Create("DScrollPanel", settingsPanel)
    settingsScroll:Dock(FILL)
    
    for name, conVarData in pairs(BaseWars.ConVar.Cache) do
        local settingContainer = vgui.Create("DPanel", settingsScroll)
        settingContainer:SetSize(settingsScroll:GetWide(), 80) -- Adjust as needed
        settingContainer:Dock(TOP) -- Auto-positions vertically
        settingContainer:DockMargin(5, 5, 5, 0)

        local titleLabel = vgui.Create("DLabel", settingContainer)
        titleLabel:Dock(TOP)
        titleLabel:SetText(conVarData.name or "No name available")
        titleLabel:SetTextColor(Color(0, 0, 0))
        titleLabel:SetFont("DermaDefaultBold")
        titleLabel:DockMargin(5, 0, 5, 2)

        local descLabel = vgui.Create("DLabel", settingContainer)
        descLabel:Dock(TOP)
        descLabel:SetText(conVarData.description or "No description available")
        descLabel:SetTextColor(Color(0, 0, 0))
        descLabel:DockMargin(5, 0, 5, 5)

        -- Determine if the convar is a boolean
        local isBool = conVarData.default == "0" or conVarData.default == "1"

        if isBool then
            -- Create a checkbox for boolean convars
            local checkBox = vgui.Create("DCheckBoxLabel", settingContainer)
            checkBox:Dock(TOP)
            checkBox:SetText("Enabled")
            checkBox:SetValue(BaseWars.ConVar.Get(name) == "1")
            checkBox:DockMargin(5, 0, 5, 10)
            checkBox.OnChange = function(self, checked)
                BaseWars.ConVar.Set(name, checked and "1" or "0")
            end
        else
            -- Create a text entry for non-boolean convars
            local textEntry = vgui.Create("DTextEntry", settingContainer)
            textEntry:Dock(TOP)
            textEntry:SetText(BaseWars.ConVar.Get(name))
            textEntry:DockMargin(5, 0, 5, 10)
            textEntry.OnEnter = function(self)
                BaseWars.ConVar.Set(name, self:GetValue())
            end
        end
    end
end
