BaseWars = BaseWars or {}
BaseWars.Entity = BaseWars.Entity or {}
BaseWars.Entity.Modules = BaseWars.Entity.Modules or {}

function BaseWars.Entity.Modules:Add(module)
    local name = module.Name

    if !name then
        print("Module has no name!")
        return
    end

    self[name] = module

    print("Module " .. name .. " added!")
end

function BaseWars.Entity.Modules:Remove(name)
    self[name] = nil
end

function BaseWars.Entity.Modules:Get(name)
    return self[name]
end

