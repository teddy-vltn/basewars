
local function CreateBaseWarsMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(700, 500)
    frame:Center()
    frame:SetTitle("BaseWars Menu")
    frame:MakePopup()

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)

    for _, navItem in pairs(BaseWars.Config.Navigation) do
        local panel = vgui.Create("DPanel", sheet)
        panel.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(60, 60, 60)) end

        if navItem.Panel then
            navItem.Panel(panel)  -- Exécutez la fonction définie dans la configuration pour remplir le panneau
        end

        sheet:AddSheet(navItem.Name, panel, navItem.Icon)
    end
end

concommand.Add("basewars_menu", CreateBaseWarsMenu)
