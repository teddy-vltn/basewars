local baseWarsMenu -- Reference to the open menu

local function CreateBaseWarsMenu()
    if IsValid(baseWarsMenu) then
        baseWarsMenu:Close()
        return
    end

    local frame = vgui.Create("BaseWars.Frame")
    frame:SetSize(700, 500)
    frame:Center()
    frame:SetTitle("BaseWars Menu")
    frame:MakePopup()

    frame.OnClose = function(self)
        baseWarsMenu = nil
    end

    -- Create the navigation bar and content area
    local navBar = vgui.Create("BaseWars.HorizontalNavBar", frame)
    navBar:Dock(TOP)
    navBar:SetBody(frame)
    navBar:SetTall(48)

    -- This panel will hold the content for each tab
    local contentArea = vgui.Create("DPanel", frame)
    contentArea:Dock(FILL)
    contentArea.Paint = function(self, w, h) -- Paint the background of the content area if needed
        draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240, 255))
    end

    for _, navItem in pairs(BaseWars.Config.Navigation) do
        local panel = vgui.Create("DPanel", contentArea)
        panel:SetSize(contentArea:GetSize()) -- Make the panel fill the content area
        panel:SetVisible(false) -- Hide the panel by default
        panel.Paint = function(self, w, h) return end -- Override if needed
        
        if navItem.Panel then
            navItem.Panel(panel)
        end

        -- Add buttons to the navigation bar
        navBar:AddTab(navItem.Name, navItem.Color, panel)
    end

    -- Open the first tab
    navBar:SetActive(1)

    baseWarsMenu = frame
    return frame
end


concommand.Add("basewars_menu", CreateBaseWarsMenu)

-- toggle button for the menu
-- when player presses F3, open the menu
hook.Add("PlayerBindPress", "OpenBaseWarsMenu", function(ply, bind, pressed)
    if bind == "gm_showspare1" and pressed then
        CreateBaseWarsMenu()
    end
end)
