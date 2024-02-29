local function CreateBaseEntityPanel(parent, name, config)

    local panel = vgui.Create("DPanel", parent)

    local configurables = config.Configurables
    local entities = config.Entities

    -- Create a diconlayout of all entities and showing their configurable values
    local iconLayout = vgui.Create("DIconLayout", panel)
    iconLayout:Dock(FILL)

    -- config.Entities[entityKey] = entityConfig

    for entityName, entityConfig in pairs(entities) do

        local entityPanel = vgui.Create("DPanel", iconLayout)
        entityPanel:SetSize(200, 200)

        local nameLabel = vgui.Create("DLabel", entityPanel)
        nameLabel:SetText(entityName)
        nameLabel:Dock(TOP)

        local configurablePanel = vgui.Create("DPanel", entityPanel)
        configurablePanel:Dock(FILL)

        for key, value in pairs(entityConfig) do
            local label = vgui.Create("DLabel", configurablePanel)
            label:SetText(key)
            label:SetTextColor(Color(0, 0, 0))
            label:Dock(TOP)
        end

        iconLayout:Add(entityPanel)
        
    end

    return panel

end

local function CreateBaseEntitiesPanel(parent)

    local panel = vgui.Create("DPanel", parent)
    panel:Dock(FILL)

    local entities = BaseWars.Config.Entities

    -- Create a DTree of the base entities names
    -- And when select an base entity name, show the entities of that base entity
    local tree = vgui.Create("DTree", panel)
    tree:Dock(LEFT)
    tree:SetWide(200)

    for name, config in pairs(entities) do 
        local node = tree:AddNode(name)
        node.DoClick = function()
            -- Create a new panel for the base entity
            local baseEntityPanel = CreateBaseEntityPanel(panel, name, config)
            baseEntityPanel:Dock(FILL)
        end
    end

    return panel
end

local function CreateShopPanel(parent)

    local panel = vgui.Create("DPanel", parent)

    return panel

end

function CreateConfigurationMenu()

    local frame = vgui.Create("DFrame")
    frame:SetSize(900, 500)
    frame:Center()
    frame:SetTitle("BaseWars Configuration")
    frame:MakePopup()

    -- Create navigation sheet one called Entities and the other called Shop
    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)
    

    -- Create the entities panel
    local entitiesPanel = CreateBaseEntitiesPanel(sheet)

    -- Create the shop panel
    local shopPanel = CreateShopPanel(sheet)

    -- Add the entities and shop panels to the navigation sheet
    sheet:AddSheet("Entities", entitiesPanel, "icon16/bricks.png")
    sheet:AddSheet("Shop", shopPanel, "icon16/cart.png")

    return frame

end


-- add concommand to open the configuration menu
concommand.Add("basewars_config", function()
    CreateConfigurationMenu()
end)