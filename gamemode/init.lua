include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}

BaseWars.Persist = BaseWars.Persist or {}

hook.Add("Initialize", "BaseWars_Initialize", function()
    if SERVER then
        BaseWars.SequentialDataSaving()
    end
end)

hook.Add("PlayerInitialSpawn", "BaseWars_PlayerInitialSpawn", function(ply)
    if not IsValid(ply) then return end

    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    -- load the player's data
    BaseWars.Persist.GetPlayerData(ply, function(data)
        ply:SetMoney(data[2])
        ply:SetLevel(data[3])
        ply:SetXP(data[4])
    end)

end)

function BaseWars.SequentialDataSaving()
    timer.Create("BaseWars_SequentialDataSaving", 120, 0, function()
        for k, v in pairs(player.GetAll()) do
            BaseWars.Persist.SaveToDatabase(v)
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

function GM:PlayerLoadout( ply )
	
    -- Give the player the weapons they bought here.
    ply:Give("weapon_physgun")
    ply:Give("gmod_tool")
    ply:Give("weapon_physcannon")

    ply:Give("weapon_fists")

	-- Prevent default Loadout.
	return true
end

hook.Add("PlayerDisconnected", "BaseWars_PlayerDisconnected", function(ply)
    if not IsValid(ply) then return end

    BaseWars.Persist.SaveToDatabase(ply)
end)

hook.Add("ShutDown", "BaseWars_ShutDown", function()
    for k, v in pairs(player.GetAll()) do
        BaseWars.Persist.SaveToDatabase(v)
    end
end)