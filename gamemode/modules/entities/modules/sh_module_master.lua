BaseWars = BaseWars or {}
BaseWars.Entity = BaseWars.Entity or {}
BaseWars.Entity.Modules = BaseWars.Entity.Modules or {}

function BaseWars.Entity.Modules:Add(name, module)
    print("Added module: " .. name)
    self[name] = module
end

function BaseWars.Entity.Modules:Remove(name)
    self[name] = nil
end

function BaseWars.Entity.Modules:Get(name)
    return self[name]
end

