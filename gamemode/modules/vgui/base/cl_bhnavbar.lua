local PANEL = {}

AccessorFunc(PANEL, "m_body", "Body")

local ui = BaseWars.Config.UI

function PANEL:Init()
    self.active = nil
    self.buttons = {}
    self.panels = {}
end

function PANEL:AddTab(name, color, panel)
    local i = table.Count(self.buttons) + 1
    self.buttons[i] = self:Add("DButton")
    local btn = self.buttons[i]
    btn:Dock(LEFT)
    btn.id = i
    btn:DockMargin(0, 2, 0, 0)
    btn:SetText(name)
    btn:SetFont("BaseWars_18")
    btn.Paint = function(pnl, w, h)
        if self.active == pnl.id then
            draw.RoundedBox(0, 0, h - 2, w, 2, color)
        end
    end
    btn:SizeToContentsX(32)
    btn:SetTextColor(ui.h2)
    btn.color = color
    btn.DoClick = function(pnl)
        self:SetActive(pnl.id)
    end

    self.panels[i] = self:GetBody():Add(panel or "DPanel")
    panel = self.panels[i]
    panel:Dock(FILL)
    panel:SetVisible(false)
end

function PANEL:SetActive(id)
    local btn = self.buttons[id]
    if not IsValid(btn) then return end

    local activeBtn = self.buttons[self.active]
    if IsValid(activeBtn) then
        activeBtn:SetTextColor(ui.h2)

        local activePanel = self.panels[self.active]
        if IsValid(activePanel) then
            activePanel:SetVisible(false)
        end
    end

    self.active = id

    btn:SetTextColor(btn.color)
    local panel = self.panels[id]
    if IsValid(panel) then
        panel:SetVisible(true)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(ui.BodyColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(ui.HeaderColor)
    surface.DrawRect(0, 0, w, 2)
end

vgui.Register("BaseWars.HorizontalNavBar", PANEL, "DPanel")
