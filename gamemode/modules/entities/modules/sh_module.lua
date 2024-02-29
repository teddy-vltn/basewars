BaseWars = BaseWars or {}
BaseWars.Entity = BaseWars.Entity or {}
BaseWars.Entity.Modules = BaseWars.Entity.Modules or {}

function BaseWars.Entity.Modules:Add(module)
    local name = module.Name

    if !name then
        BaseWars.Log("Module has no name, not adding!")
        return
    end

    self[name] = module

    BaseWars.Log("Added module " .. name)
end

function BaseWars.Entity.Modules:Get(name)
    return self[name]
end


