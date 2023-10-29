local baseWarsMenu -- Reference to the open menu

local function CreateBaseWarsMenu()
    if IsValid(baseWarsMenu) then -- If the menu is already open, close it
        baseWarsMenu:Close()
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(700, 500)
    frame:Center()
    frame:SetTitle("BaseWars Menu")
    frame:MakePopup()

    frame.OnClose = function(self)
        baseWarsMenu = nil -- Reset the reference when the menu is closed
    end

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)

    for _, navItem in pairs(BaseWars.Config.Navigation) do
        local panel = vgui.Create("DPanel", sheet)
        panel.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(60, 60, 60)) end

        if navItem.Panel then
            navItem.Panel(panel) 
        end

        sheet:AddSheet(navItem.Name, panel, navItem.Icon)
    end

    baseWarsMenu = frame -- Store a reference to the open menu
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
