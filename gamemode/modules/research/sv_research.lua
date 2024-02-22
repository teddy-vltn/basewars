local ply = FindMetaTable("Player")

function BaseWars.Research.OpenMenu(ent, ply)
    local netTag = BaseWars.Research.Net.OpenResearchMenu

    BaseWars.Net.SendToPlayer(ply, netTag, {
        ent = ent
    })
end

function BaseWars.Research.ResearchModule(ent, moduleName, ply)
    local netTag = BaseWars.Research.Net.ResearchModule

    local module = BaseWars.Research.GetModuleByName(moduleName)

    -- set the entity's researching 
    ent:SetResearching(true)
    ent:SetResearchTimeLeft(module.time(0))
    ent:SetResearchTime(module.time(0))
    ent:SetResearchModule(moduleName)
    --ent:SetResearchModuleCost(module.cost(0))

    ent.LastResearchTick = CurTime()

    BaseWars.Log("Player " .. ply:Name() .. " is researching " .. moduleName .. " on entity " .. tostring(ent))

end

net.Receive(BaseWars.Research.Net.ResearchModule, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Research.Net.ResearchModule)

    local ent = data.ent
    local module = data.module

    BaseWars.Research.ResearchModule(ent, module, ply)
end)

function BaseWars.Research.InitializePlayer(ply)
    for _, module in pairs(BaseWars.Config.Research) do
        ply:SetNWInt("bw_research_" .. module.Name, 0)
    end
end

function BaseWars.Research.ApplyEffect(ply, module)
    local level = ply:GetResearchLevel(module.Name)

    if level > 0 then
        module.Apply(ply, level)
    end
end

function BaseWars.Research.ApplyAllEffects(ply)
    for _, module in pairs(BaseWars.Config.Research) do
        BaseWars.Research.ApplyEffect(ply, module)
    end
end

function ply:AddResearchLevel(module)
    local level = self:GetResearchLevel(module)

    self:SetNWInt("bw_research_" .. module, level + 1)
end




