include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}


-- on player initial spawn
function GM:PlayerInitialSpawn(ply)
    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    BaseWars.Faction.CreateFaction("Test Faction", "me", "password", "icon16/gun.png")
    BaseWars.Faction.CreateFaction("Test Faction 2", "me", "", "icon16/gun.png")

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