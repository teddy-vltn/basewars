BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Menu = nil

local function CreateFactionCreationMenu(callback)
    local frame = vgui.Create("DFrame")
    frame:SetSize(500, 360)
    frame:Center()
    frame:SetTitle(BaseWars.Lang("FactionCreate"))
    frame:MakePopup()

    local nameLabel = vgui.Create("DLabel", frame)
    nameLabel:Dock(TOP)
    nameLabel:SetText(BaseWars.Lang("FactionName") .. ":")
    nameLabel:DockMargin(10, 10, 10, 0)

    local nameEntry = vgui.Create("DTextEntry", frame)
    nameEntry:Dock(TOP)
    nameEntry:SetTall(25)
    nameEntry:DockMargin(10, 5, 10, 5)

    local colorPicker = vgui.Create("DColorMixer", frame)
    colorPicker:Dock(TOP)
    colorPicker:SetTall(110)
    colorPicker:DockMargin(10, 5, 10, 5)
    colorPicker:SetPalette(true)
    colorPicker:SetAlphaBar(false)
    colorPicker:SetWangs(true)
    colorPicker:SetColor(Color(255, 255, 255))

    local iconList = vgui.Create("DIconLayout", frame)
    iconList:Dock(TOP)
    iconList:DockMargin(10, 5, 10, 5)
    iconList:SetSpaceX(6)
    iconList:SetSpaceY(6)

    local icons = {
        "icon16/accept.png",
        "icon16/add.png",
        "icon16/anchor.png",
        "icon16/application.png",
        "icon16/application_add.png",
        "icon16/award_star_gold_1.png",
        "icon16/flag_red.png",
        "icon16/shield.png"
    }

    local selectedIcon = icons[1]

    for _, iconName in ipairs(icons) do
        local iconButton = iconList:Add("DImageButton")
        iconButton:SetSize(16, 16)
        iconButton:SetImage(iconName)
        iconButton.DoClick = function()
            selectedIcon = iconName
        end
    end

    local createButton = vgui.Create("DButton", frame)
    createButton:Dock(BOTTOM)
    createButton:SetText(BaseWars.Lang("FactionCreate"))
    createButton:DockMargin(10, 10, 10, 10)
    createButton:SetEnabled(false)

    nameEntry.OnChange = function()
        createButton:SetEnabled(#nameEntry:GetValue() >= 3)
    end

    createButton.DoClick = function()
        if callback then
            callback({
                Name = nameEntry:GetValue(),
                Color = colorPicker:GetColor(),
                Password = "",
                Icon = selectedIcon
            })
        end

        frame:Close()
    end
end

local function AskForComfirmation(factionName, callback)
    Derma_Query(
        BaseWars.Lang("FactionLeaveAreYouSure", factionName),
        BaseWars.Lang("AreYouSure"),
        BaseWars.Lang("Yes"),
        callback,
        BaseWars.Lang("No")
    )
end

local function ShowFactionDetails(panel, factionName, factionData)
    local localSteamID = LocalPlayer():SteamID()
    local isInFaction = LocalPlayer():GetFaction() == factionName
    local isLeader = factionData:GetLeader() == localSteamID

    local title = vgui.Create("DLabel", panel)
    title:Dock(TOP)
    title:SetText(factionName)
    title:SetFont("DermaLarge")
    title:SetContentAlignment(5)
    title:DockMargin(0, 10, 0, 5)

    local leader = vgui.Create("DLabel", panel)
    leader:Dock(TOP)
    leader:SetText(BaseWars.Lang("FactionLeader") .. ": " .. (factionData.LeaderName or factionData:GetLeader() or "Unknown"))
    leader:SetContentAlignment(5)
    leader:DockMargin(0, 0, 0, 10)

    local listView = vgui.Create("DListView", panel)
    listView:Dock(FILL)
    listView:SetMultiSelect(false)
    listView:AddColumn(BaseWars.Lang("Members"))
    listView:AddColumn("SteamID")
    listView:AddColumn("Status")

    for steamID, member in pairs(factionData:GetMembers()) do
        local name = member.name or steamID
        local status = member.online and "Online" or "Offline"
        local line = listView:AddLine(name, steamID, status)
        line.SteamID = steamID
    end

    local buttonPanel = vgui.Create("DPanel", panel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(32)
    buttonPanel.Paint = function() end

    local leaveButton = vgui.Create("DButton", buttonPanel)
    leaveButton:SetText(BaseWars.Lang("FactionLeave"))
    leaveButton:Dock(LEFT)
    leaveButton:SetWide(120)
    leaveButton:SetVisible(isInFaction)
    leaveButton.DoClick = function()
        AskForComfirmation(factionName, function()
            BaseWars.Faction.TryLeaveFaction(factionName)
        end)
    end

    local inviteButton = vgui.Create("DButton", buttonPanel)
    inviteButton:SetText(BaseWars.Lang("FactionInvite"))
    inviteButton:Dock(LEFT)
    inviteButton:SetWide(120)
    inviteButton:SetVisible(isLeader)
    inviteButton.DoClick = function()
        Derma_StringRequest(
            BaseWars.Lang("FactionInvite"),
            BaseWars.Lang("FactionInvitePrompt"),
            "",
            function(text)
                BaseWars.Faction.TryInvitePlayer(text)
            end
        )
    end

    local kickButton = vgui.Create("DButton", buttonPanel)
    kickButton:SetText(BaseWars.Lang("FactionKick"))
    kickButton:Dock(LEFT)
    kickButton:SetWide(120)
    kickButton:SetVisible(isLeader)
    kickButton.DoClick = function()
        local selectedIndex = listView:GetSelectedLine()
        if not selectedIndex then return end

        local selectedLine = listView:GetLine(selectedIndex)
        local steamID = selectedLine.SteamID or selectedLine:GetColumnText(2)
        if steamID == localSteamID then return end

        BaseWars.Faction.TryKickPlayer(steamID)
    end
end

function CreateFactionPanel(parent)
    BaseWars.Faction.Menu = parent
    local lastClickedFaction = nil

    local factionPanel = vgui.Create("DPanel", parent)
    factionPanel:Dock(FILL)

    local splitter = vgui.Create("DHorizontalDivider", factionPanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(220)

    local tree = vgui.Create("DTree", splitter)
    splitter:SetLeft(tree)

    local createFactionButton = vgui.Create("DButton", factionPanel)
    createFactionButton:Dock(BOTTOM)
    createFactionButton:SetText(BaseWars.Lang("FactionCreate"))
    createFactionButton:DockMargin(10, 10, 10, 10)
    createFactionButton.DoClick = function()
        CreateFactionCreationMenu(function(factionData)
            BaseWars.Faction.TryCreateFaction(factionData.Name, factionData.Password, factionData.Color, factionData.Icon)
        end)
    end

    local factionDetails = vgui.Create("DPanel", splitter)
    splitter:SetRight(factionDetails)

    function parent:RefreshFactionData()
        tree:Clear()

        local factions = BaseWars.Faction.GetFactions()
        local nodeToClick = nil

        for factionName, factionData in pairs(factions) do
            local factionNode = tree:AddNode(factionName .. " (" .. factionData:GetMemberCount() .. ")")
            factionNode.Icon:SetImage(factionData:GetIcon())

            factionNode.DoClick = function()
                factionDetails:Clear()
                ShowFactionDetails(factionDetails, factionName, factionData)
                lastClickedFaction = factionName
            end

            if factionName == lastClickedFaction then
                nodeToClick = factionNode
            end
        end

        if IsValid(nodeToClick) then
            nodeToClick:DoClick()
        else
            factionDetails:Clear()
        end
    end

    parent:RefreshFactionData()

    return factionPanel
end
