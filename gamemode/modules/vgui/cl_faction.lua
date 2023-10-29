BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Menu = nil

local function AskForPassword(factionName, callback)
    local passwordFrame = vgui.Create("DFrame")
    passwordFrame:SetSize(300, 150)
    passwordFrame:Center()
    passwordFrame:SetTitle("Mot de passe requis")
    passwordFrame:MakePopup()

    local infoLabel = vgui.Create("DLabel", passwordFrame)
    infoLabel:Dock(TOP)
    infoLabel:SetText("Veuillez entrer le mot de passe pour rejoindre la faction " .. factionName)
    infoLabel:SizeToContents()
    infoLabel:DockMargin(10, 10, 10, 10)

    local passwordEntry = vgui.Create("DTextEntry", passwordFrame)
    passwordEntry:Dock(TOP)
    passwordEntry:SetTall(25)
    passwordEntry:DockMargin(10, 0, 10, 10)
    passwordEntry:SetPlaceholderText("Mot de passe...")

    local submitButton = vgui.Create("DButton", passwordFrame)
    submitButton:Dock(BOTTOM)
    submitButton:SetText("Soumettre")
    submitButton:DockMargin(10, 5, 10, 10)
    submitButton.DoClick = function()
        local password = passwordEntry:GetValue()

        if callback then
            callback(password) -- Appeler la fonction de callback avec le mot de passe entré
        end

        passwordFrame:Close()
    end
end

local function AskForComfirmation(factionName, callback)
    local confirmationFrame = vgui.Create("DFrame")
    confirmationFrame:SetSize(300, 150)
    confirmationFrame:Center()
    confirmationFrame:SetTitle("Confirmation")
    confirmationFrame:MakePopup()

    local infoLabel = vgui.Create("DLabel", confirmationFrame)
    infoLabel:Dock(TOP)
    infoLabel:SetText("Êtes-vous sûr de vouloir quitter la faction " .. factionName .. " ?")
    infoLabel:SizeToContents()
    infoLabel:DockMargin(10, 10, 10, 10)

    local submitButton = vgui.Create("DButton", confirmationFrame)
    submitButton:Dock(BOTTOM)
    submitButton:SetText("Oui")
    submitButton:DockMargin(10, 5, 10, 10)
    submitButton.DoClick = function()
        if callback then
            callback() -- Appeler la fonction de callback
        end

        confirmationFrame:Close()
    end

    local cancelButton = vgui.Create("DButton", confirmationFrame)
    cancelButton:Dock(BOTTOM)
    cancelButton:SetText("Non")
    cancelButton:DockMargin(10, 5, 10, 10)
    cancelButton.DoClick = function()
        confirmationFrame:Close()
    end
end


local function ShowFactionDetails(panel, factionName, factionData)

    -- Titre de la faction
    local title = vgui.Create("DLabel", panel)
    title:Dock(TOP)
    title:SetText(factionName)
    title:SetFont("DermaLarge")
    title:SetContentAlignment(5)
    title:DockMargin(0, 10, 0, 10)

    -- Liste des membres
    local listView = vgui.Create("DListView", panel)
    listView:Dock(FILL)
    listView:SetMultiSelect(false)
    listView:AddColumn("Membres")

    for member, _ in pairs(factionData.Members) do
        listView:AddLine(member) -- Suppose que 'member' est un objet Player. Si ce n'est pas le cas, ajustez en conséquence.
    end

    -- Boutons pour rejoindre/quitter la faction
    local buttonPanel = vgui.Create("DPanel", panel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(30)
    buttonPanel.Paint = function() end


    local joinButton = vgui.Create("DButton", buttonPanel)
    joinButton:SetText("Rejoindre")
    joinButton:Dock(LEFT)
    joinButton.DoClick = function()
        if BaseWars.Faction.HasFactionPassword(factionName) then
            AskForPassword(factionName, function(password)
                BaseWars.Faction.TryJoinFaction(factionName, password)
            end)
        else
            BaseWars.Faction.TryJoinFaction(factionName, "")
        end
    end

    local leaveButton = vgui.Create("DButton", buttonPanel)
    leaveButton:SetText("Quitter")
    leaveButton:Dock(LEFT)
    leaveButton.DoClick = function()
        AskForComfirmation(factionName, function()
            BaseWars.Faction.TryLeaveFaction(factionName)
        end)
    end

    buttonPanel.Think = function()
        -- Si le joueur est dans la faction, affichez le bouton de quitter
        -- Sinon, affichez le bouton de rejoindre
        local isInFaction = LocalPlayer():GetFaction() == factionName
        joinButton:SetVisible(!isInFaction)
        leaveButton:SetVisible(isInFaction)
    end

end

function CreateFactionPanel(parent)

    BaseWars.Faction.Menu = parent
    local lastClickedFaction = nil

    local factionPanel = vgui.Create("DPanel", parent)
    factionPanel:Dock(FILL)

    local splitter = vgui.Create("DHorizontalDivider", factionPanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(200)

    local tree = vgui.Create("DTree", splitter)
    splitter:SetLeft(tree)

    local factionDetails = vgui.Create("DPanel", splitter)
    splitter:SetRight(factionDetails)

    function parent:RefreshFactionData()
        tree:Clear()

        local factions = BaseWars.Faction.GetFactions()
        local nodeToClick = nil  -- this will store the node that needs to be clicked after refreshing

        for factionName, factionData in pairs(factions) do
            local isOpenString = !BaseWars.Faction.HasFactionPassword(factionName) and " (Ouvert)" or " (Fermé)"
            local factionNode = tree:AddNode(factionName .. isOpenString)
            factionNode.Icon:SetImage(factionData.Icon)

            factionNode.DoClick = function()
                factionDetails:Clear()
                ShowFactionDetails(factionDetails, factionName, factionData)
                lastClickedFaction = factionName
            end

            -- if this faction was the last clicked faction, store its node
            if factionName == lastClickedFaction then
                nodeToClick = factionNode
            end
        end

        -- If there was a previously clicked faction, simulate a click on it
        if nodeToClick then
            nodeToClick:DoClick()
        end
    end


    parent:RefreshFactionData()
end
