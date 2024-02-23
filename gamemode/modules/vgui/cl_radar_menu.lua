local userMaterial = Material("icon16/user.png")
local entitiesMaterial = Material("icon16/brick.png")
local radarOwnMaterial = Material("icon16/arrow_in.png")
local radarMaterial = Material("icon16/radar.png")


function OpenRadarMenu(radar)
    local frame = vgui.Create("DFrame")

    local w, h = ScrW() * 0.3, ScrH() * 0.3

    frame:SetSize(w, h)
    frame:Center()
    frame:SetTitle("Radar")
    frame:MakePopup()

    local entities = BaseWars.Radar.Radars[radar:EntIndex()] or {}

    local blackMap = vgui.Create("DPanel", frame)
    blackMap:Dock(FILL)
    blackMap.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    for _, ent in pairs(entities) do
        if not IsValid(ent) then continue end

        local pos = ent:GetPos()
        local radarPos = radar:GetPos()
        local x, y = WorldToRadar(radarPos, pos, w, h)

        -- Create a clickable icon for each entity
        local icon = vgui.Create("DButton", blackMap)
        icon:SetSize(10, 10) -- Set the size of the icon
        icon:SetPos(x - 5, y - 5) -- Center the icon on its position
        icon:SetText("") -- No text
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

        -- Function to show entity info when the icon is clicked
        icon.DoClick = function()
            local info = "Entity Info:\nClass: " .. ent:GetClass() -- Example info
            if ent:IsPlayer() then
                info = info .. "\nName: " .. ent:Name() -- Add player name if it's a player
            end
            -- Display the info in a simple message box
            Derma_Message(info, "Entity Information", "Close")
        end
    end
end


function WorldToRadar(radarPos, entPos, panelWidth, panelHeight)
    local scale = 0.05 -- Adjust this scale factor to fit your needs

    -- Calculate the relative position of the entity to the radar
    local diff = entPos - radarPos

    -- Scale the difference and adjust for the panel size
    local x = (diff.x * scale) + (panelWidth / 2)
    local y = (diff.y * scale) + (panelHeight / 2)

    -- Invert y-axis to match the game's coordinate system with the panel's
    y = panelHeight - y

    -- Clamp the coordinates to the panel's size to ensure they stay within bounds
    x = math.Clamp(x, 0, panelWidth)
    y = math.Clamp(y, 0, panelHeight)

    return x, y
end

