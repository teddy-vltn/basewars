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

/*
    @description
    Sells an entity for a player.

    @param {Player} ply - The player selling the entity.
    @param {Entity} ent - The entity being sold.
*/
function BaseWars.Entities.SellEntity(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return end

    print("Selling entity in the function")

    if not ent:CanSell() then
        BaseWars.Notify.Send(ply, "You cannot sell this entity!")
        return
    end

    local value = ent:GetValue() or 0
    local owner = ent:CPPIGetOwner()

    print(owner)

    if not IsValid(owner) then 
        
        BaseWars.Log(ply, " attempted to sell an entity that does not have an owner!")

        return 
    end

    if owner ~= ply then
        BaseWars.Log(ply, " attempted to sell an entity that does not belong to them!")
        BaseWars.Notify.Send(ply,  "You cannot sell an entity that does not belong to you!")
        return
    end

    /*if not ent:CanSell() then
        BaseWars.Notify.Send(ply, "You cannot sell this entity!")
        return
    end*/

    ply:AddMoney(value)
    ent:Remove()

    BaseWars.Notify.Send(ply, "You sold an entity for " .. value .. "!")
end

/*
    @description
    Upgrades an entity for a player.

    @param {Player} ply - The player upgrading the entity.
    @param {Entity} ent - The entity being upgraded.
    @param {string} upgrade - The upgrade being applied.
*/

function BaseWars.Entities.UpgradeEntity(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return end

    local owner = ent:CPPIGetOwner()

    if not IsValid(owner) then return end

    ent:Upgrade()
end

-- Receive selling entity from client
net.Receive(BaseWars.Entities.Net.Sell, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Entities.Net.Sell)

    local ent = data.entity

    if not IsValid(ent) then 
        BaseWars.Log(ply, " attempted to sell an entity that does not exist!")
        return 
    end

    BaseWars.Entities.SellEntity(ply, ent)
end)

-- Receive upgrading entity from client
net.Receive(BaseWars.Entities.Net.Upgrade, function(len, ply)
    local data = BaseWars.Net.Read(BaseWars.Entities.Net.Upgrade)

    local ent = data.entity

    if not IsValid(ent) then return end

    BaseWars.Entities.UpgradeEntity(ply, ent, upgrade)
end)
