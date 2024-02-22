include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}
BaseWars.Persist = BaseWars.Persist or {}
BaseWars.Leaderboard = BaseWars.Leaderboard or {}
BaseWars.Research = BaseWars.Research or {}

hook.Add("Initialize", "BaseWars_Initialize", function()
    if SERVER then
        BaseWars.SequentialDataSaving()
    end
end)

hook.Add("PlayerInitialSpawn", "BaseWars_PlayerInitialSpawn", function(ply)
    if not IsValid(ply) then return end

    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    BaseWars.Research.InitializePlayer(ply)

    if BaseWars.Config.Debug then
        BaseWars.Notify.Send(ply, "Debug", "Debug mode is enabled.", Color(255, 255, 255))

        ply:SetMoney(10^6)
        ply:SetLevel(100)
        ply:SetXP(0)

        ply.CorruptedData = true

        return
    end

    -- load the player's data
    BaseWars.Persist.GetPlayerData(ply, function(data)
        if not data then
            BaseWars.Notify.Send(ply, "Error", "An error occured while loading your data. Please contact an administrator.", Color(255, 0, 0))

            -- freeze the player
            ply:Freeze(BaseWars.Config.Globals.FreezePlaterWhenDataLoadingError)

            ply:SetMoney(BaseWars.Config.Globals.DefaultMoney)
            ply:SetLevel(BaseWars.Config.Globals.DefaultLevel)
            ply:SetXP(BaseWars.Config.Globals.DefaultXP)

            ply.CorruptedData = true

            return
        end

        ply:SetMoney(data[2])
        ply:SetLevel(data[3])
        ply:SetXP(data[4])

        -- send the player the leaderboard
        BaseWars.Leaderboard.Send(ply)
    end)

end)

hook.Add("Think", "BaseWars_Think", function()
    BaseWars.Leaderboard.Think()
end)

function BaseWars.SequentialDataSaving()
    timer.Create("BaseWars_SequentialDataSaving", 180, 0, function()
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

    BaseWars.Research.ApplyAllEffects(ply)

end)

function GM:PlayerLoadout( ply )
	
    ply:Give("weapon_physgun")
    ply:Give("gmod_tool")
    ply:Give("weapon_physcannon")

    ply:Give("weapon_fists")

    ply:Give("bw_inspector")

    ply:Give("weapon_pistol")

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