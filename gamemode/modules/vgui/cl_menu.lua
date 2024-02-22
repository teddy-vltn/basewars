local baseWarsMenu
local isMenuOpen = false

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}
BaseWars.ConVar = BaseWars.ConVar or {}

BaseWars.Config._MenuFocus = false
BaseWars.Config._LastMenuOpen = "0"

local function CreateBaseWarsMenu()

    local frame = vgui.Create("DFrame")
    frame:SetSize(900, 500)
    frame:Center()
    frame:SetTitle("BaseWars Menu")
    frame:MakePopup()

    frame.OnClose = function()
        isMenuOpen = false
    end

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)

    -- Save the last tab open
    sheet.OnActiveTabChanged = function(self, old, new)
        if !IsValid(new) then return end

        BaseWars.Config._LastMenuOpen = new:GetText()
    end

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

    if BaseWars.Config._LastMenuOpen != 0 then
        sheet:SwitchToName(BaseWars.Config._LastMenuOpen)
    end

    return frame
end

concommand.Add("basewars_menu", CreateBaseWarsMenu)

hook.Add("SpawnMenuOpen", "OpenBaseWarsMenu", function()
    return false
end)

local menuOpenKey --= BaseWars.Config.MenuOpenKey.keycode 
local menuAlwaysOpen --= BaseWars.Config.MenuAlwaysFocus.value

hook.Add("Think", "CloseBaseWarsMenu", function()

    -- Skip if the player is typing in chat or the console is open
    if IsValid(vgui.GetKeyboardFocus()) && !isMenuOpen then return end
    if gui.IsConsoleVisible() then return end

    menuOpenKey = BaseWars.Config.MenuOpenKey.keycode
    menuAlwaysOpen = BaseWars.Config.MenuAlwaysFocus.value

    if input.IsKeyDown(KEY_F1) || input.IsKeyDown(menuOpenKey) then

        if !isMenuOpen then
            baseWarsMenu = CreateBaseWarsMenu()
            isMenuOpen = true

            -- Work here tho for some reason
            -- Reset the focus for the menu to properly close when the user is not holding the key
            -- if another widget didn't take the focus
            BaseWars.Config._MenuFocus = menuAlwaysOpen or false
        end
    else
        if isMenuOpen && !BaseWars.Config._MenuFocus && IsValid(baseWarsMenu) then
            baseWarsMenu:Close()
            isMenuOpen = false

            -- Apparently doesn't work here weird champ
            --BaseWars.Config._MenuFocus = false
        end
    end
end)

-- if user presses F1, open the menu
hook.Add("ShowHelp", "OpenBaseWarsMenu", function()
    CreateBaseWarsMenu()
end)
