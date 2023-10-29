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
        -- Logic pour rejoindre la faction
    end

    -- Seulement montrer le bouton de quitter si le joueur est déjà dans la faction
    if LocalPlayer().Faction == factionName then
        local leaveButton = vgui.Create("DButton", buttonPanel)
        leaveButton:SetText("Quitter")
        leaveButton:Dock(RIGHT)
        leaveButton.DoClick = function()
            -- Logic pour quitter la faction
        end
    end

end

function CreateFactionPanel(parent)
    PrintTable(BaseWars.Faction)

    local factionPanel = vgui.Create("DPanel", parent)
    factionPanel:Dock(FILL)

    local splitter = vgui.Create("DHorizontalDivider", factionPanel)
    splitter:Dock(FILL)
    splitter:SetLeftWidth(200)

    local tree = vgui.Create("DTree", splitter)
    splitter:SetLeft(tree)

    local factionDetails = vgui.Create("DPanel", splitter)
    splitter:SetRight(factionDetails)

    local factions = BaseWars.Faction.GetFactions()

    for factionName, factionData in pairs(factions) do

        local isOpenString = factionData.Password and " (Open)" or " (Closed)"

        local factionNode = tree:AddNode(factionName .. isOpenString)

        -- set icon to faction icon
        factionNode.Icon:SetImage(factionData.Icon)

        factionNode.DoClick = function()
            -- Affiche les détails de la faction sur le panneau droit

            factionDetails:Clear()

            ShowFactionDetails(factionDetails, factionName, factionData)
        
        end
    end
end
