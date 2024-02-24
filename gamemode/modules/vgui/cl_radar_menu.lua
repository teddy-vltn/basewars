local userMaterial = Material("icon16/user.png")
local entitiesMaterial = Material("icon16/brick.png")
local radarOwnMaterial = Material("icon16/arrow_in.png")
local radarMaterial = Material("icon16/radar.png")

function OpenRadarMenu(radar)
    local frame = vgui.Create("DFrame")
    local w, h = ScrW() * 0.3, ScrH() * 0.5
    local infoPanelWidth = 200 -- Width for the info panel

    frame:SetSize(w + infoPanelWidth, h) -- Adjust frame width to accommodate info panel
    frame:Center()
    frame:SetTitle("Radar")
    frame:MakePopup()

    local entities = BaseWars.Radar.Radars[radar:EntIndex()] or {}

    -- Radar panel
    local blackMap = vgui.Create("DPanel", frame)
    blackMap:SetSize(w - infoPanelWidth, h)
    blackMap:Dock(FILL)
    blackMap.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    -- Info panel
    local infoPanel = vgui.Create("DPanel", frame)
    infoPanel:SetSize(infoPanelWidth, h)
    infoPanel:Dock(RIGHT)
    infoPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 255))
    end

    -- Info text
    local infoText = vgui.Create("DLabel", infoPanel)
    infoText:SetPos(10, 10)
    infoText:SetSize(infoPanelWidth - 20, h - 120) -- Adjust height to leave space for buttons
    infoText:SetWrap(true)
    infoText:SetText("Click an entity on the radar to see information here.")

    local selectedEnt = nil
    
    for _, ent in pairs(entities) do
        if not IsValid(ent) then continue end

        local pos = ent:GetPos()
        local radarPos = radar:GetPos()
        local x, y = WorldToRadar(radarPos, pos, w - infoPanelWidth, h) -- Adjusted for new radar panel size

        local icon = vgui.Create("DButton", blackMap)
        icon:SetSize(10, 10)
        icon:SetPos(x - 5, y - 5)
        icon:SetText("")
        icon.Paint = function(self, w, h)
            if ent == radar then
                surface.SetMaterial(radarOwnMaterial)
            elseif ent.IsRadar then
                surface.SetMaterial(radarMaterial)
            elseif ent:IsPlayer() then
                surface.SetMaterial(userMaterial)
            elseif ent.IsBaseWars then
                surface.SetMaterial(entitiesMaterial)
            end
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        icon.DoClick = function()
            local info = "Entity Info:\nClass: " .. ent:GetClass()
            if ent:IsPlayer() then
                info = info .. "\nName: " .. ent:Name()
            end
            infoText:SetText(info)
            selectedEnt = ent
        end
    end

    -- Scan button
    local scanBtn = vgui.Create("DButton", infoPanel)
    scanBtn:Dock(BOTTOM)
    scanBtn:SetText("Scan")
    scanBtn.DoClick = function()
        local ownerSelectedEnt = selectedEnt:CPPIGetOwner()

        info = "Scanning...\n"

        info = info .. "\nClass: " .. selectedEnt:GetClass()
        if selectedEnt.PrintName then
            info = info .. "\nName: " .. selectedEnt.PrintName
        end

        if IsValid(ownerSelectedEnt) then
            info = info .. "\nOwner: " .. ownerSelectedEnt:Nick()
        end
        
        infoText:SetText(info)
    end
    scanBtn.Think = function(self)
        if not IsValid(radar) then
            frame:Close()
        end

        if not IsValid(selectedEnt) then
            self:SetDisabled(true)
        else
            self:SetDisabled(false)
        end
    end

    -- Raid button
    local raidBtn = vgui.Create("DButton", infoPanel)
    raidBtn:Dock(BOTTOM)
    raidBtn:SetText("Raid")
    raidBtn.DoClick = function()
        if not IsValid(selectedEnt) then return end

        BaseWars.Log("Raiding ", selectedEnt, " with ", radar)
    end
    raidBtn.Think = function(self)
        if not IsValid(radar) then
            frame:Close()
        end

        if not IsValid(selectedEnt) then
            self:SetDisabled(true)
        else
            self:SetDisabled(false)
        end
    end
end

function WorldToRadar(radarPos, entPos, panelWidth, panelHeight)
    local scale = 0.05
    local diff = entPos - radarPos
    local x = (diff.x * scale) + (panelWidth / 2)
    local y = (diff.y * scale) + (panelHeight / 2)
    y = panelHeight - y -- Invert y-axis
    x = math.Clamp(x, 0, panelWidth)
    y = math.Clamp(y, 0, panelHeight)
    return x, y
end
