local function AttemptResearch(ent, module)

    BaseWars.Net.SendToServer(BaseWars.Research.Net.ResearchModule, {
        ent = ent,
        module = module
    })

end

local needRefreshTable = false

local function ResearchMenu(ent)
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    frame:Center()
    frame:SetTitle("Research Menu")
    frame:SetDraggable(true)
    frame:ShowCloseButton(true)
    frame:MakePopup()

    local isResearching = ent:GetResearching()
    local researchTimeLeft = ent:GetResearchTimeLeft()
    local researchTime = ent:GetResearchTime()
    local researchModule = ent:GetResearchModule()

    -- ui 
    -- dlistview of all the research modules
    -- can select one and click research
    -- a progress bar is always shown at the bottom of the screen
    -- if the player is researching something, show the progress bar
    -- if the player is not researching anything, hide the progress bar
    local dlistview = vgui.Create("DListView", frame)
    dlistview:Dock(FILL)
    dlistview:SetMultiSelect(false)
    dlistview:AddColumn("Name")
    dlistview:AddColumn("Description")
    dlistview:AddColumn("Level")
    dlistview:AddColumn("Time")
    dlistview:AddColumn("Cost")

    local progressBar 

    function dlistview:Refresh()
        self:Clear()

        if IsValid(progressBar) then
            progressBar:SetVisible(isResearching)
        end

        for _, module in pairs(BaseWars.Config.Research) do
            if module.Name and module.Description then
                local level = LocalPlayer():GetResearchLevel(module.Name)
                print(level)
                local time = module.time(level)
                local cost = module.cost(level)
                dlistview:AddLine(module.Name, module.Description, level, time, cost)
            end
        end
    end

    function dlistview:Think()
        if needRefreshTable then
            self:Refresh()
            needRefreshTable = false
        end
    end

    dlistview:Refresh()

    local researchButton = vgui.Create("DButton", frame)
    researchButton:Dock(BOTTOM)
    researchButton:SetText("Research")
    researchButton:SetTall(50)
    researchButton:SetDisabled(true)

    progressBar = vgui.Create("DProgress", frame)
    progressBar:Dock(BOTTOM)
    progressBar:SetTall(50)
    progressBar:SetFraction(0)
    progressBar:SetVisible(isResearching)

    dlistview.OnRowSelected = function(self, index, row)
        if not isResearching then
            researchButton:SetDisabled(false)
        end
    end

    researchButton.DoClick = function()
        local selectedLine = dlistview:GetSelectedLine()
        local selectedModule = dlistview:GetLine(selectedLine)

        if selectedModule then
            local moduleName = selectedModule:GetValue(1)
            local moduleCost = selectedModule:GetValue(3)

            AttemptResearch(ent, moduleName)

            progressBar:SetVisible(true)
            researchButton:SetDisabled(true)
        end
    end

    progressBar.Think = function(self)

        isResearching = ent:GetResearching()
        researchTimeLeft = ent:GetResearchTimeLeft()
        researchTime = ent:GetResearchTime()
        researchModule = ent:GetResearchModule()

        if isResearching then
            if researchTimeLeft > 0 then
                self:SetFraction(1 - researchTimeLeft / researchTime)
            else
                self:SetVisible(false)
                self:SetFraction(0)
            end
        end
    end

end

net.Receive(BaseWars.Research.Net.OpenResearchMenu, function(len)
    local data = BaseWars.Net.Read(BaseWars.Research.Net.OpenResearchMenu)

    ResearchMenu(data.ent)
end)

net.Receive(BaseWars.Research.Net.FinishedResearch, function(len)
    local data = BaseWars.Net.Read(BaseWars.Research.Net.FinishedResearch)

    local ent = data.ent

    needRefreshTable = true
end)
