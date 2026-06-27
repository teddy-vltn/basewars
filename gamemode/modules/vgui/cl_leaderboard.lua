
net.Receive(BaseWars.Leaderboard.Net.RefreshLeaderboard, function(len)
    local data = BaseWars.Net.Read(BaseWars.Leaderboard.Net.RefreshLeaderboard)

    BaseWars.Leaderboard.Cache = data.leaderboard

    BaseWars.Log("Leaderboard refreshed.")
end)

function CreateLeaderboardPanel(parent)
    local leaderboardPanel = vgui.Create("DPanel", parent)
    leaderboardPanel:Dock(FILL)

    local leaderboard = vgui.Create("DListView", leaderboardPanel)
    leaderboard:Dock(FILL)
    leaderboard:SetMultiSelect(false)

    leaderboard:AddColumn("SteamID")
    leaderboard:AddColumn("Money")
    leaderboard:AddColumn("Level")

    -- Current page
    local currentPage = 0

    local function RefreshLeaderboard(page)
        leaderboard:Clear()
        local pageData = BaseWars.Leaderboard.Cache[page]

        if pageData then
            for _, playerData in pairs(pageData) do
                leaderboard:AddLine(playerData[1], playerData[2], playerData[3])
            end
        end
    end

    local panelBottom = vgui.Create("DPanel", leaderboardPanel)
    panelBottom:Dock(BOTTOM)
    panelBottom:SetTall(30)

    -- need to init it here so forward and back buttons can access it
    local pageDisplay

    -- Forward Button
    local forwardButton = vgui.Create("DButton", panelBottom)
    forwardButton:Dock(RIGHT)
    forwardButton:SetText(">")
    forwardButton.DoClick = function()
        if BaseWars.Leaderboard.Cache[currentPage + 1] then
            currentPage = currentPage + 1
            pageDisplay:SetText("Page " .. currentPage)
            RefreshLeaderboard(currentPage)
        end
    end

    pageDisplay = vgui.Create("DLabel", panelBottom)
    pageDisplay:Dock(RIGHT)
    pageDisplay:SetText("Page " .. currentPage)
    pageDisplay:SetTextColor(Color(40, 40, 40))

    -- Back Button
    local backButton = vgui.Create("DButton", panelBottom)
    backButton:Dock(RIGHT)
    backButton:SetText("<")
    backButton.DoClick = function()
        if currentPage > 0 then
            currentPage = currentPage - 1
            pageDisplay:SetText("Page " .. currentPage)
            RefreshLeaderboard(currentPage)
        end
    end

    local refreshButton = vgui.Create("DButton", panelBottom)
    refreshButton:Dock(LEFT)
    refreshButton:SetText("Refresh")
    refreshButton.DoClick = function()
        RefreshLeaderboard(currentPage)
    end

    -- Initial Refresh
    RefreshLeaderboard(currentPage)

    return leaderboardPanel
end


    


    
    