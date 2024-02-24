BaseWars = BaseWars or {}

local L = {}

L.MoneyCurrency = "$"

L.Debug = "Debug"
L.DebugIsEnabled = "Debug mode is enabled."

L.Error = "Error"
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

L.Printer = "Printer"
L.Generator = "Generator"
L.Turret = "Turret"
L.Tesla = "Tesla"
L.Dispenser = "Dispenser"

L.Health = "Health"
L.Armor = "Armor"
L.Ammo = "Ammo"

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
L.FactionPasswordIncorrect = "The password is incorrect."

L.Buy = "Buy"
L.Sell = "Sell"
L.Upgrade = "Upgrade"

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

L.PlayerPayOut = "You have been paid %s."
L.PlayerPayOutError = "You can't be paid right now."

BaseWars.RegisterLanguage("EN", L)