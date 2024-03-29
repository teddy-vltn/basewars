BaseWars = BaseWars or {}
BaseWars.Faction = BaseWars.Faction or {}
BaseWars.Faction.Menu = nil

local function AskForPassword(factionName, callback)
    local passwordFrame = vgui.Create("DFrame")
    passwordFrame:SetSize(300, 150)
    passwordFrame:Center()
    passwordFrame:SetTitle(BaseWars.Lang("FactionPasswordNeeded") .. " " .. factionName)
    passwordFrame:MakePopup()

    local infoLabel = vgui.Create("DLabel", passwordFrame)
    infoLabel:Dock(TOP)
    infoLabel:SetText(BaseWars.Lang("FactionPleaseInputPassword") .. factionName)
    infoLabel:SizeToContents()
    infoLabel:DockMargin(10, 10, 10, 10)

    local passwordEntry = vgui.Create("DTextEntry", passwordFrame)
    passwordEntry:Dock(TOP)
    passwordEntry:SetTall(25)
    passwordEntry:DockMargin(10, 0, 10, 10)
    passwordEntry:SetPlaceholderText(BaseWars.Lang("FactionPassword") .. "...")

    local submitButton = vgui.Create("DButton", passwordFrame)
    submitButton:Dock(BOTTOM)
    submitButton:SetText(BaseWars.Lang("Submit"))
    submitButton:DockMargin(10, 5, 10, 10)
    submitButton.DoClick = function()
        local password = passwordEntry:GetValue()

        if callback then
            callback(password) -- Appeler la fonction de callback avec le mot de passe entré
        end

        passwordFrame:Close()
    end
end

local function CreateFactionCreationMenu(callback)

    local frame = vgui.Create("DFrame")
    frame:SetSize(500, 400)
    frame:Center()
    frame:SetTitle(BaseWars.Lang("FactionCreate"))
    frame:MakePopup()

    -- Champ de texte pour le nom
    local nameLabel = vgui.Create("DLabel", frame)
    nameLabel:Dock(TOP)
    nameLabel:SetText(BaseWars.Lang("FactionName") .. ":")
    nameLabel:DockMargin(10, 10, 10, 0)

    local nameEntry = vgui.Create("DTextEntry", frame)
    nameEntry:Dock(TOP)
    nameEntry:SetTall(25)
    nameEntry:DockMargin(10, 5, 10, 5)

    -- Choix de couleur
    local colorPicker = vgui.Create("DColorMixer", frame)
    colorPicker:Dock(TOP)
    colorPicker:SetTall(100)
    colorPicker:DockMargin(10, 5, 10, 5)
    colorPicker:SetPalette(true)
    colorPicker:SetAlphaBar(true)
    colorPicker:SetWangs(true)
    colorPicker:SetColor(Color(255, 255, 255))

    -- Choix de mot de passe (optionnel)
    local passwordLabel = vgui.Create("DLabel", frame)
    passwordLabel:Dock(TOP)
    passwordLabel:SetText(BaseWars.Lang("FactionPassword") .. ":" .. " ( " .. BaseWars.Lang("Optional") .. " )")
    passwordLabel:DockMargin(10, 10, 10, 0)

    local passwordEntry = vgui.Create("DTextEntry", frame)
    passwordEntry:Dock(TOP)
    passwordEntry:SetTall(25)
    passwordEntry:DockMargin(10, 5, 10, 5)

    -- Choix d'icône pour la faction
    local iconList = vgui.Create("DIconLayout", frame)
    iconList:Dock(TOP)
    iconList:DockMargin(10, 5, 10, 5)
    iconList:SetSpaceY(5)

    local icons = { -- This is an example list. You can expand it.
        "icon16/accept.png", "icon16/add.png", "icon16/anchor.png",
        "icon16/application.png", "icon16/application_add.png"
        -- ... Add more icons as needed
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
    createButton:SetEnabled(false) -- Désactivez le bouton par défaut
    
    -- Cette fonction vérifie la validité du nom de la faction
    local function isFactionNameValid(name)
        -- Exemple de validation: le nom doit comporter au moins 3 caractères. 
        -- Vous pouvez ajouter d'autres conditions si nécessaire.
        return #name >= 3
    end
    
    -- Mettez à jour l'état du bouton chaque fois que le contenu du champ de texte change
    nameEntry.OnChange = function()
        createButton:SetEnabled(isFactionNameValid(nameEntry:GetValue()))
    end
    
    createButton.DoClick = function()
        -- Get the data from the form
        local factionData = {
            Name = nameEntry:GetValue(),
            Color = colorPicker:GetColor(),
            Password = passwordEntry:GetValue(),
            Icon = selectedIcon
        }

        -- If a callback function is provided, send the data to it
        if callback then
            callback(factionData)
        end

        frame:Close() -- Close the creation frame
    end

end


local function AskForComfirmation(factionName, callback)
    local confirmationFrame = vgui.Create("DFrame")
    confirmationFrame:SetSize(300, 150)
    confirmationFrame:Center()
    confirmationFrame:SetTitle(BaseWars.Lang("AreYouSure"))
    confirmationFrame:MakePopup()

    local infoLabel = vgui.Create("DLabel", confirmationFrame)
    infoLabel:Dock(TOP)
    infoLabel:SetText(BaseWars.Lang("FactionLeaveAreYouSure", factionName))
    infoLabel:SizeToContents()
    infoLabel:DockMargin(10, 10, 10, 10)

    local submitButton = vgui.Create("DButton", confirmationFrame)
    submitButton:SetText(BaseWars.Lang("Yes"))
    submitButton:Dock(BOTTOM)
    submitButton:DockMargin(10, 5, 10, 10)
    submitButton.DoClick = function()
        if callback then
            callback() -- Appeler la fonction de callback
        end

        confirmationFrame:Close()
    end

    local cancelButton = vgui.Create("DButton", confirmationFrame)
    cancelButton:Dock(BOTTOM)
    cancelButton:SetText(BaseWars.Lang("No"))
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
    listView:AddColumn(BaseWars.Lang("Members"))

    for member, _ in pairs(factionData.Members) do
        -- Ajoutez chaque nom de membre à la liste
        listView:AddLine(member:Nick() || member:Name())
    end

    -- Boutons pour rejoindre/quitter la faction
    local buttonPanel = vgui.Create("DPanel", panel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(30)
    buttonPanel.Paint = function() end


    local joinButton = vgui.Create("DButton", buttonPanel)
    joinButton:SetText(BaseWars.Lang("FactionJoin"))
    joinButton:Dock(LEFT)
    joinButton.DoClick = function()
        if factionData:HasPassword() then
            AskForPassword(factionName, function(password)
                BaseWars.Faction.TryJoinFaction(factionName, password)
            end)
        else
            BaseWars.Faction.TryJoinFaction(factionName, "")
        end
    end

    local leaveButton = vgui.Create("DButton", buttonPanel)
    leaveButton:SetText(BaseWars.Lang("FactionLeave"))
    leaveButton:Dock(LEFT)
    leaveButton.DoClick = function()
        AskForComfirmation(factionName, function()
            BaseWars.Faction.TryLeaveFaction(factionName)
        end)
    end

    local kickButton = vgui.Create("DButton", buttonPanel)
    kickButton:SetText(BaseWars.Lang("FactionKick"))
    kickButton:Dock(LEFT)
    kickButton.DoClick = function()
        local selectedIndex = listView:GetSelectedLine() -- This is the index of the selected line
        if selectedIndex then
            local selectedLine = listView:GetLine(selectedIndex) -- Retrieve the line object using the index
            local playerName = selectedLine:GetColumnText(1) -- Now you can safely call GetColumnText
            BaseWars.Faction.TryKickPlayer(playerName)
        end
    end

    buttonPanel.Think = function()
        -- Si le joueur est dans la faction, affichez le bouton de quitter
        -- Sinon, affichez le bouton de rejoindre
        local isInFaction = LocalPlayer():GetFaction() == factionName
        joinButton:SetVisible(!isInFaction)
        leaveButton:SetVisible(isInFaction)
        kickButton:SetVisible(isInFaction)
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

    -- bottom of dtree add a button to create a faction
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

        PrintTable(BaseWars.Faction.Factions)
        local factions = BaseWars.Faction.GetFactions()
        local nodeToClick = nil  -- this will store the node that needs to be clicked after refreshing

        for factionName, factionData in pairs(factions) do
            local factionNode = tree:AddNode(factionName)
            factionNode.Icon:SetImage(factionData:GetIcon())

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
            -- Check if node still exists eg. if the faction was deleted while the menu was open
            if IsValid(nodeToClick) then
                nodeToClick:DoClick()
            else 
                lastClickedFaction = nil
                factionDetails:Clear()
            end
        else -- If there is no node to click, clear the details panel
            factionDetails:Clear()
        end
    end

    parent:RefreshFactionData()

    return factionPanel
end
