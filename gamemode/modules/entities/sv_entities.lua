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

    -- Check if player is not too far from the entity
    if not BaseWars.ValidClose(ply, ent, 200) then
        BaseWars.Notify.Send(ply, "You are too far away from the entity!")
        return
    end

    if not ent:CanSell() then
        BaseWars.Notify.Send(ply, "You cannot sell this entity!")
        return
    end

    local owner = ent:CPPIGetOwner()

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

    -- Will call the remove hook and give the player money back no need to do it here
    -- ply:AddMoney(value)
    ent:Remove()

    local value = ent:GetValue()
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

    ent:Upgrade(ply)
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

-- On entity removed recover money from entity
hook.Add("EntityRemoved", "BaseWars_EntityRemoved", function(ent)
    if not IsValid(ent) then return end
    if not ent:CPPIGetOwner() then return end
    if not ent:CPPIGetOwner():IsPlayer() then return end

    local owner = ent:CPPIGetOwner()

    if not IsValid(owner) then return end

    --if not ent:CanSell() then return end
    if not ent.GetValue then return end

    -- Check if the entity health had reached 0
    if ent:Health() <= 0 then
        BaseWars.Notify.Send(owner, "Your entity was destroyed!", " ", Color(255, 0, 0))

        owner:AddMoney(ent:GetValue() / 2)

        return
    end

    owner:AddMoney(ent:GetValue())
end)
