local PANEL = {}

-- Set consistent margins for elements
PANEL.Margin = 6

local ui = BaseWars.Config.UI

function PANEL:Init()
    self.Header = self:Add("DPanel")
    self.Header:Dock(TOP)
    self.Header.Paint = function(pnl, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ui.HeaderColor)

        -- Draw a line at the bottom of the header
        surface.SetDrawColor(ui.HeaderLineColor)
        surface.DrawRect(0, h - 1, w, 1)
    end

    self.Header.CloseBtn = self.Header:Add("DButton")
    self.Header.CloseBtn:Dock(RIGHT)
    self.Header.CloseBtn:SetText("Close")
    self.Header.CloseBtn:SetFont("BaseWars_18_Bold")
    self.Header.CloseBtn:SetTextColor(ui.CloseBtnTextColor)
    self.Header.CloseBtn.DoClick = function(pnl)
        self:Remove()
    end
    self.Header.CloseBtn.Paint = function(pnl, w, h)
        local margin = self.Margin
    end
    
    self.Header.Title = self.Header:Add("DLabel")
    self.Header.Title:Dock(LEFT)
    self.Header.Title:SetFont("BaseWars_22") 
    self.Header.Title:SetTextColor(ui.TitleTextColor)
    self.Header.Title:SetTextInset(self.Margin, 0)
end

function PANEL:SetTitle(text)
    self.Header.Title:SetText(text)
    self.Header.Title:SizeToContents()
end

function PANEL:PerformLayout(w, h)
    local margin = self.Margin

    self.Header:SetTall(36) -- Replace with your desired header height
    self.Header.CloseBtn:SetWide(60)
    self.Header.Title:DockMargin(margin, 0, 0, 0)
end

function PANEL:Paint(w, h)
    local aX, aY = self:LocalToScreen(0, 0)

    -- BSHADOW
    BSHADOWS.BeginShadow()
        draw.RoundedBox(0, aX, aY, w, h, Color(0, 0, 0, 255))
    BSHADOWS.EndShadow(1, 3, 6, 200, -90, 5, false)

    draw.RoundedBox(0, 0, self.Header:GetTall(), w, h - self.Header:GetTall(), ui.BodyColor)
end


vgui.Register("BaseWars.Frame", PANEL, "EditablePanel")
