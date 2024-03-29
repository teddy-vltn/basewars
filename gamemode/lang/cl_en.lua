BaseWars = BaseWars or {}

local L = {}

L.MoneyCurrency = "$"

L.Debug = "Debug"
L.DebugIsEnabled = "Debug mode is enabled."

L.Yes = "Yes"
L.No = "No"

L.Error = "Error"
L.Success = "Success"
L.Submit = "Submit"
L.Page = "Page"
L.AreYouSure = "Are you sure?"
L.AnErrorOccured = "An error occured."
L.AnErrorOccuredWhileLoadingData = "An error occured while loading your data. Please contact an administrator."
L.AnErrorOccuredWhileSavingData = "An error occured while saving your data. Please contact an administrator."

L.InvalidPlayer = "Invalid Player"

L.Props = "Props"
L.Entities = "Entities"
L.Tools = "Tools"
L.Leaderboard = "Leaderboard"
L.Shop = "Shop"
L.Settings = "Settings"

L.Money = "Money"
L.PayOut = "Pay Out"
L.Level = "Level"
L.XP = "XP"
L.XPToNextLevel = "XP to next level"

L.Health = "Health"
L.Armor = "Armor"
L.Ammo = "Ammo"

L.Bank = "Bank"

L.Power = "Power"
L.PowerCapacity = "Power Capacity"
L.PowerConsumption = "Power Consumption"
L.PowerGeneration = "Power Generation"

L.Name = "Name"
L.Color = "Color"
L.Icon = "Icon"

L.Members = "Members"

L.Next = "Next"
L.Previous = "Previous"
L.Current = "Current"

L.PayOutForPlaying = "You have been paid %s for playing on the server."

L.Faction = "Faction"
L.FactionPassword = "Faction Password"
L.FactionName = "Faction Name"
L.FactionDescription = "Faction Description"
L.FactionColor = "Faction Color"
L.FactionLeader = "Faction Leader"
L.FactionMembers = "Faction Members"
L.FactionCreate = "Create Faction"
L.FactionJoin = "Join Faction"
L.FactionLeave = "Leave Faction"
L.FactionKick = "Kick from Faction"
L.FactionPasswordNeeded = "Password Needed"
L.FactionPasswordIncorrect = "The password is incorrect."
L.FactionPleaseInputPassword = "Please input the password of the faction."
L.FactionLeaveAreYouSure = "Are you sure you want to leave the faction %s?"

L.Cost = "Cost"
L.Value = "Value"
L.Buy = "Buy"
L.Sell = "Sell"
L.Upgrade = "Upgrade"
L.UpgradeLevel = "Upgrade Level"

L.AreYouSureYouWannaBuy = "Are you sure you want to buy %s for %s?"
L.AreYouSureYouWannaSell = "Are you sure you want to sell %s for %s?"
L.AreYouSureYouWannaUpgrade = "Are you sure you want to upgrade %s for %s?"

L.NotEnoughMoneyToBuyUpgrade = "You don't have enough money to buy this upgrade."
L.CantSellThisEntity = "You can't sell this entity."
L.CantSellOtherPlayersEntities = "You can't sell other players' entities."

L.Refresh = "Refresh"

L.Search = "Search"

L.Optionnal = "Optionnal"

L.RaidableEntities = "Raidable Entities"

L.Welcome = "Welcome to %s !"
L.CreatedFaction = "You have created the faction %s."
L.FactionAlreadyExists = "The faction %s already exists."
L.FactionLeft = "You have left the faction %s."
L.FactionDeleted = "You have deleted the faction %s."
L.FactionKicked = "You have been kicked from the faction %s."
L.FactionCannotKickOwner = "You cannot kick the owner of the faction."
L.FactionKickedPlayer = "You have kicked %s from the faction."
L.FactionNotMember = "You are not a member of a faction."
L.FactionPlayerNotMemberOfThisFaction = "%s is not a member of the faction."
L.FactionNotOwner = "You are not the owner of the faction."
L.FactionAlreadyMember = "You are already a member of a faction."
L.FactionDoesntExist = "The faction %s doesn't exist."
L.FactionCantCreate = "You can't create a faction."
L.FactionCantJoin = "You can't join the faction %s."
L.FactionCantLeave = "You can't leave the faction %s."
L.FactionCantKick = "You can't kick %s from the faction."
L.JoinedFaction = "You have joined the faction %s."
L.NotInFaction = "You are not in a faction."
L.NameCannotBeEmpty = "The name cannot be empty."
L.NameIsTooShort = "Name is too short. Minimum 3 characters."
L.NameIsTooLong = "Name is too long. Maximum 32 characters."
L.PasswordIsTooLong = "Password is too long. Maximum 32 characters."
L.NameContainsInvalidCharacters = "Name contains invalid characters."
L.ColorCannotBeEmpty = "Color cannot be empty."
L.IconCannotBeEmpty = "Icon cannot be empty."

L.Raid = "Raid"
L.Raiding = "Raiding"
L.RaidingSuccess = "You have successfully raided %s."
L.RaidingFailed = "You have failed to raid %s."
L.RaidingSomeone = "You are being raided by %s."
L.RaidingEnded = "The raid between %s and %s has ended."
L.RaidingStarted = "The raid between %s and %s has started."
L.RaidingWillBeginIn = "The raid between %s and %s will begin in %s."
L.RaidingAttackerLostTickets = "The attacker has lost all of his tickets."
L.RaidingAttackerHasLostSomeTickets = "The attacker has lost %s tickets."
L.RaidingTimeLeft = "Time left: %s"
L.RaidingAlready = "You are already raiding %s."
L.RaidingIsOnCooldown = "You can't raid %s right now."
L.RaidingIsOnCooldownFor = "You can't raid %s for %s."
L.RaidingIsOnCooldownForAll = "You can't raid anyone for %s."

L.Research = "Research"
L.Researching = "Researching"
L.ResearchingSuccess = "You have successfully researched %s."
L.ResearchingFailed = "You have failed to research %s."
L.ResearchingTimeLeft = "Time left: %s"

L.EntityHasBeenBought = "You have bought the entity (%s) for %s."
L.EntityHasBeenDestroyed = "Your entity (%s) has been destroyed. You have been paid %s."
L.EntityHasBeenDestroyedBy = "Your entity (%s) has been destroyed by %s. You have been paid %s."
L.EntityHasBeenDestroyedBySomeone = "Your entity (%s) has been destroyed by someone. You have been paid %s."

L.TooFarAwayToInteract = "You are too far away to interact with this entity."

L.SpawnMenu = "Spawn Menu"
L.UpgradedEntity = "You have upgraded your entity (%s) to level %s."
L.SoldEntity = "You have sold your entity (%s) for %s."
L.BoughtEntity = "You have bought the entity (%s) for %s."
L.LimitReached = "You have reached the limit for this entity. %s / %s"
L.EntityDoesntExist = "The entity (%s) doesn't exist??? Please contact an administrator."
L.SuccessfullySpawnedEntity = "Successfully spawned entity."
L.NotEnoughMoney = "You don't have enough money to buy this entity."
L.NotEnoughLevel = "You don't have the required level to buy this entity."

L.BoughtWeapon = "You have bought the weapon (%s) for %s."
L.AutoBuy = "Auto Buy"
L.AutoBuyAreYouSure = "Are you sure you want to enable the auto buy for this weapon?"
L.ActivatedBuyOnRespawn = "You have activated the buy on respawn for the weapon (%s)."
L.DeactivatedBuyOnRespawn = "You have deactivated the buy on respawn for all weapons."

L.ActivatedSpawnpoint = "You will now respawn at this spawnpoint."
L.DeactivatedSpawnpoint = "You will no longer respawn at this spawnpoint."

L.YouMustBeAPlayerToUseThis = "You must be a player to use this."

L.PickedMoney = "You have picked %s" .. L.MoneyCurrency .. "."
L.PickedMoneyError = "You can't pick money right now."

L.PlayerPayOut = "You have been paid %s."
L.PlayerPayOutError = "You can't be paid right now."

-- General shop translations
L.Printer = "Printer"
L.Printers = "Printers"
L.Generator = "Generator"
L.Generators = "Generators"
L.Turret = "Turret"
L.Turrets = "Turrets"
L.Tesla = "Tesla"
L.Teslas = "Teslas"
L.Dispenser = "Dispenser"
L.Dispensers = "Dispensers"
L.Basic = "Basic"
L.Advanced = "Advanced"
L.Elite = "Elite"
L.Basics = "Basics"
L.Fun = "Fun"
L.Weapons = "Weapons"
L.General = "General"
L.Farm = "Farm"
L.VIP = "VIP"
L.Pistol = "Pistol"
L.Pistols = "Pistols"
L.Rifle = "Rifle"
L.Rifles = "Rifles"
L.Shotgun = "Shotgun"
L.Shotguns = "Shotguns"
L.Sniper = "Sniper"
L.Snipers = "Snipers"
L.Machinegun = "Machinegun"
L.Machineguns = "Machineguns"
L.Explosive = "Explosive"
L.Explosives = "Explosives"
L.Melee = "Melee"
L.Spawn = "Spawn"
L.SpawnPoint = "Spawn Point"

BaseWars.RegisterLanguage("EN", L)