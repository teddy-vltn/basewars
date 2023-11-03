BaseWars = BaseWars or {}
BaseWars.Entities = BaseWars.Entities or {}

function BaseWars.Entities.FindPlayerEntities(ply)
    local entities = {}

    for k, v in pairs(ents.GetAll()) do
        if v:CPPIGetOwner() == ply then
            table.insert(entities, v)
        end
    end

    return entities
end