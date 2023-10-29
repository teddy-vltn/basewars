include("shared.lua")

BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}

function GM:Initialize()
    
    -- create random faction to test
    BaseWars.Faction.Initialize()
end

-- on player initial spawn
function GM:PlayerInitialSpawn(ply)
    -- send the player the notification list
    BaseWars.Notify.Send(ply, "Welcome to BaseWars!", "Welcome to BaseWars! Press F1 to open the menu.", Color(255, 255, 255))

    BaseWars.Faction.CreateFaction("Test Faction", "me", "password", "icon16/gun.png")
    BaseWars.Faction.CreateFaction("Test Faction 2", "me", "", "icon16/gun.png")

    -- send the player the faction list
    BaseWars.Faction.SyncFactions(ply)


end
