include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}


-- on player initial spawn
function GM:PlayerInitialSpawn(ply)
    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    -- Faction.new(name, password, color, icon)
    BaseWars.Faction.CreateFaction("Default", "yes", BaseWars.Color("RED"), "icon16/gun.png", ply)


    -- send the player the faction list
    BaseWars.Faction.SyncFactions(ply)


end

hook.Add("PlayerSpawn", "BaseWars_SpawnPoint", function(ply)
    if not IsValid(ply) then return end

    local spawnPoint = ply.SpawnPoint

    if IsValid(spawnPoint) then
        ply:SetPos(spawnPoint:GetPos() + Vector(0, 0, 10))
    end
end)