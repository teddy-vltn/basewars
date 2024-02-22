BaseWars = BaseWars or {}
BaseWars.Research = BaseWars.Research or {}

local ply = FindMetaTable("Player")

BaseWars.Research.Net = BaseWars.Research.Net or {
    OpenResearchMenu = "Research_OpenResearchMenu",
    ResearchModule = "Research_ResearchModule",
    FinishedResearch = "Research_FinishedResearch"
}

BaseWars.Net.Register(BaseWars.Research.Net.OpenResearchMenu, {ent = "Entity"})
BaseWars.Net.Register(BaseWars.Research.Net.ResearchModule, {ent = "Entity", module = "string" })
BaseWars.Net.Register(BaseWars.Research.Net.FinishedResearch, {ent = "Entity"})

function ply:GetResearchLevel(module)
    return self:GetNWInt("bw_research_" .. module, 0)
end

function BaseWars.Research.GetModuleByName(name)
    for _, module in pairs(BaseWars.Config.Research) do
        if module.Name == name then
            return module
        end
    end
end
