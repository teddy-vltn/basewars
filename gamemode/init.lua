include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}

BaseWars.Persist = BaseWars.Persist or {}


-- on player initial spawn
function GM:PlayerInitialSpawn(ply)
    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    -- Faction.new(name, password, color, icon)


    -- send the player the faction list

    print(BaseWars.Persist.GetPlayer(ply))



end

hook.Add("PlayerSpawn", "BaseWars_SpawnPoint", function(ply)
    if not IsValid(ply) then return end

    local spawnPoint = ply.SpawnPoint

    if IsValid(spawnPoint) then
        ply:SetPos(spawnPoint:GetPos() + Vector(0, 0, 10))
    end
end)