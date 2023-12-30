include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}

BaseWars.Persist = BaseWars.Persist or {}

hook.Add("Initialize", "BaseWars_Initialize", function()
    -- load the database
    if SERVER then
        BaseWars.SequentialDataSaving()
    end
end)

hook.Add("PlayerInitialSpawn", "BaseWars_PlayerInitialSpawn", function(ply)
    if not IsValid(ply) then return end

    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    -- skip to next think
    timer.Simple(1, function()
        -- load the player from the database
        BaseWars.Persist.LoadFromDatabase(ply)
    end)
end)

function BaseWars.SequentialDataSaving()
    timer.Create("BaseWars_SequentialDataSaving", 5, 0, function()
        for k, v in pairs(player.GetAll()) do
            --BaseWars.Persist.SaveToDatabase(v)
        end
    end)
end

hook.Add("PlayerSpawn", "BaseWars_SpawnPoint", function(ply)
    if not IsValid(ply) then return end

    local spawnPoint = ply.SpawnPoint

    if IsValid(spawnPoint) then
        ply:SetPos(spawnPoint:GetPos() + Vector(0, 0, 10))
    end
end)