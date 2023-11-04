function BaseWars.Props.FindPlayerProps(ply)
    local props = {}

    for _, ent in pairs(ents.GetAll()) do
        if ent.Base == "prop_physics" and ent:CPPIGetOwner() == ply then
            table.insert(props, ent)
        end
    end

    return props
end

    