BaseWars = BaseWars or {}
BaseWars.Entities = BaseWars.Entities or {}

/*
    @description
    Returns all entities owned by a player.

    @param {Player} ply - The player to find entities for.
*/
function BaseWars.Entities.FindPlayerEntities(ply)
    local entities = {}

    for k, v in pairs(ents.GetAll()) do
        if v:CPPIGetOwner() == ply then
            table.insert(entities, v)
        end
    end

    return entities
end