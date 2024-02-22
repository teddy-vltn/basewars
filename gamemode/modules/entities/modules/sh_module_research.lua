local BW_RESEARCH_MODULE = {}
BW_RESEARCH_MODULE.__index = BW_RESEARCH_MODULE

-- Constants
local MODULE_NAME = "Research"
local MODULE_DESC = "Allows you to research new modules"

-- Initialization
function BW_RESEARCH_MODULE.New()
    local self = setmetatable({}, BW_RESEARCH_MODULE)

    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"ResearchTimeLeft", 0, "Int"},
        {"ResearchTime", 0, "Int"},
        {"Researching", false, "Bool"},
        {"ResearchModule", "", "String"},
        {"ResearchModuleCost", 0, "Int"},
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module

    return self
end

function BW_RESEARCH_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized

    print("Research module initialized for entity: ", ent)
end

function BW_RESEARCH_MODULE:OnThink(ent)
    if CLIENT then return end

    -- Check if the entity was initialized with this module
    if not self.InitializedEntities[ent] then return end

    if ent:GetResearching() then
        local ResearchTimeLeft = ent:GetResearchTimeLeft()

        if ResearchTimeLeft > 0 and ent.LastResearchTick + 1 <= CurTime() then
            ent:SetResearchTimeLeft(ResearchTimeLeft - 1)
            ent.LastResearchTick = CurTime()
            BaseWars.Log("Researching " .. ent:GetResearchModule() .. " on entity " .. tostring(ent) .. " for " .. ent:GetResearchTimeLeft() .. " more seconds")
        elseif ResearchTimeLeft <= 0 then

            BaseWars.Log("Researching " .. ent:GetResearchModule() .. " on entity " .. tostring(ent) .. " is done")

            local module = BaseWars.Research.GetModuleByName(ent:GetResearchModule())

            if module then
                -- CPPiGetOwner is a function from the CPPi library
                local owner = ent:CPPIGetOwner()

                if owner then
                    owner:AddResearchLevel(ent:GetResearchModule())
                    
                    BaseWars.Research.ApplyEffect(owner, module)

                    BaseWars.Log("Player " .. owner:Name() .. " has researched " .. ent:GetResearchModule() .. " on entity " .. tostring(ent))

                    -- Send a net message to the client to update the research menu
                    -- Create a timer for next tick of server tick
                    -- Prevents for the menu of the player to be confused on which level the player is
                    timer.Simple(0.1, function()
                        BaseWars.Net.SendToPlayer(owner, BaseWars.Research.Net.FinishedResearch, {ent = ent})
                    end)

                    -- Send a notification to the player
                    BaseWars.Notify.Send(owner, "Research", "You have succesfully researched " .. ent:GetResearchModule(), Color(0, 255, 0))
                end
            end

            ent:SetResearching(false)
            ent:SetResearchTimeLeft(0)
            ent:SetResearchTime(0)
            ent:SetResearchModule("")
        end
    end

    return true
end

function BW_RESEARCH_MODULE:Use(ent, ply)
    if not ply:IsPlayer() then return end

    -- Check if the entity was initialized with this module
    if not self.InitializedEntities[ent] then return end

    BaseWars.Research.OpenMenu(ent, ply)
end

local researchModuleInstance = BW_RESEARCH_MODULE.New()
BaseWars.Entity.Modules:Add(researchModuleInstance)