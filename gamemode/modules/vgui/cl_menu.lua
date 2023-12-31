local baseWarsMenu -- Reference to the open menu

local function CreateBaseWarsMenu()
    if IsValid(baseWarsMenu) then
        baseWarsMenu:Close()
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(900, 500)
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
        panel.Paint = function(self, w, h) return end

        -- margin
        local margin = 2
        panel:DockMargin(margin, margin, margin, margin)

        if navItem.Panel then
            navItem.Panel(panel) 
        end

        sheet:AddSheet(navItem.Name, panel, navItem.Icon)
    end

    baseWarsMenu = frame
    return frame
end


concommand.Add("basewars_menu", CreateBaseWarsMenu)

hook.Add("SpawnMenuOpen", "OpenBaseWarsMenu", function()
    if not IsValid(baseWarsMenu) then
        CreateBaseWarsMenu()
    end

    return false -- Prevent the default spawn menu from opening
end)
