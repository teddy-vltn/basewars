# BaseWars 

This gamemode is a re-write from scratch of a popular gamemode that has been discontinued. This projet is heavily maintened by myself, and I'm open to any suggestions or pull requests. You can at the same time if you want click here to join the [Discord](https://discord.gg/NJWEGHDaNd) server. 

**!! This gamemode is still in development, and is not ready to be used on an active server !!**

## Table of Contents

- [Description](#description)
- [Installation](#installation)
- [Documentation](#documentation)
  - [Client Side Functions](#client-side-functions)
  - [Shared Side Functions](#shared-side-functions)
  - [Server Side Functions](#server-side-functions)

## Description

The BaseWars gamemode is a gamemode where you can build your own base, buy weapons, and fight against other players. You can also create your own faction, and raid other factions. 

The gamemode contains a lot of features, and is very customizable. You can add your own weapons, entities, and more.

Almost all can be done through the config file, and the gamemode is very easy to setup. There is no need of an in-depth knowledge of lua to setup the gamemode.

Nonetheless if you want to add your own weapons, entities, or anything else, you will need to know lua and how the structure of the gamemode works.

## Installation

Simply download the gamemode, and put it in your server's gamemodes folder.

## Documentation
### Client-Side Functions

> ***Located at modules/net/cl_net.lua: Line 4***
```lua
function BaseWars.Net.SendToServer(msgType, data)
```


Send a network message to the server.

- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.

---

> ***Located at modules/spawnmenu/cl_spawnmenu.lua: Line 6***
```lua
function Player:BuyEntity(uuid)
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/cl_spawnmenu.lua: Line 12***
```lua
function Player:SetAutoBuy(bool, weapon)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 4***
```lua
function BaseWars.ConVar.Register(var, name, default, helpText)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 16***
```lua
function BaseWars.ConVar.CreateConVarHandler(convarName, isBool)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 47***
```lua
function BaseWars.ConVar.Get(name)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 56***
```lua
function BaseWars.ConVar.Set(name, value)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 60***
```lua
function BaseWars.ConVar.Reset(name)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 64***
```lua
function BaseWars.ConVar.GetDefault(name)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 68***
```lua
function BaseWars.ConVar.GetDescription(name)
```


No documentation available for now.

---

> ***Located at modules/persistent/cl_persistent.lua: Line 72***
```lua
function BaseWars.ConVar.GetVar(name)
```


No documentation available for now.

---

> ***Located at modules/faction/cl_faction.lua: Line 57***
```lua
function BaseWars.Faction.TryJoinFaction(name, password)
```


Attempts to join a faction with the given name and password.

- **Parameter** `name` (string): The name of the faction to join.
- **Parameter** `password` (string): The password of the faction to join.

---

> ***Located at modules/faction/cl_faction.lua: Line 68***
```lua
function BaseWars.Faction.TryLeaveFaction(name)
```


Attempts to leave the faction with the given name.

- **Parameter** `name` (string): The name of the faction to leave.

---

> ***Located at modules/faction/cl_faction.lua: Line 78***
```lua
function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
```


Attempts to delete the faction with the given name.

- **Parameter** `name` (string): The name of the faction to delete.

---

> ***Located at modules/faction/cl_faction.lua: Line 88***
```lua
function BaseWars.Faction.TryKickPlayer(target)
```


No documentation available for now.

---

### Shared-Side Functions

> ***Located at shared.lua: Line 16***
```lua
function BaseWars.Log(...)
```


Logs a message to the console.

@param {any} ... - The message to log.

---

> ***Located at shared.lua: Line 29***
```lua
function BaseWars.Color(code)
```


Loads a module.

- **Parameter** `name` (string): The name of the module to load.

---

> ***Located at shared.lua: Line 49***
```lua
function BaseWars.ValidClose(ply, ent, range)
```


No documentation available for now.

---

> ***Located at shared.lua: Line 55***
```lua
function BaseWars.FindPlayerByName(name)
```


No documentation available for now.

---

> ***Located at shared.lua: Line 63***
```lua
function BaseWars.NumberFormat(n)
```


No documentation available for now.

---

> ***Located at shared.lua: Line 78***
```lua
function BaseWars.FormatMoney(n)
```


Formats a number into a money string.

- **Parameter** `n` (number): The number to format.

---

> ***Located at shared.lua: Line 88***
```lua
function BaseWars.CreateFakeDerivatedScriptedEnt(baseEntity, printName, model, ClassName)
```


Registers a new entity based on an existing entity. Fake registering without having to create a new file.

- **Parameter** `baseEntity` (string): The base entity to derive from.
- **Parameter** `printName` (string): The name of the entity.
- **Parameter** `model` (string): The model of the entity.
- **Parameter** `ClassName` (string): The class name of the entity.

---

> ***Located at shared.lua: Line 111***
```lua
function BaseWars.CreateFakeDerivedWeapon(baseWeapon, newPrintName, newClassName, customizations)
```


Registers a new weapon based on an existing weapon. Fake registering without having to create a new file.

- **Parameter** `baseWeapon` (string): The base weapon to derive from.
- **Parameter** `newPrintName` (string): The name of the weapon.
- **Parameter** `newClassName` (string): The class name of the weapon.
- **Parameter** `customizations` (function): A function to customize the weapon.

---

> ***Located at shared.lua: Line 142***
```lua
function BaseWars.LoadEntityConfiguration()
```


Loads Entity configuration from the config file, in order to create entities.

---

> ***Located at shared.lua: Line 177***
```lua
function BaseWars.LoadWeaponConfiguration()
```


No documentation available for now.

---

> ***Located at modules/sh_modules.lua: Line 6***
```lua
function BaseWars.RegisterModule(name, dependencies, path, prefix)
```


Registers a module with optional dependencies.

- **Parameter** `name` (string): The name of the module.
- **Parameter** `dependencies` (table): A table of dependencies for the module.
- **Parameter** `path` (string): The path to the module.
- **Parameter** `prefix` (string): The prefix of the module.

---

> ***Located at modules/sh_modules.lua: Line 59***
```lua
function BaseWars.IncludeModules()
```


Loads all modules in the order they were registered.

---

> ***Located at modules/sh_modules.lua: Line 75***
```lua
function BaseWars.RegisterModuleFolder(folder, dependencies)
```


Registers all modules in a folder with optional dependencies.

- **Parameter** `folder` (string): The folder to register modules in.
- **Parameter** `dependencies` (table): A table of dependencies to use for all modules in the folder.

---

> ***Located at modules/research/sh_research.lua: Line 20***
```lua
function BaseWars.Research.GetModuleByName(name)
```


No documentation available for now.

---

> ***Located at modules/net/sh_net.lua: Line 51***
```lua
function BaseWars.Net.Register(msgType, structure)
```


Register a network message type.

- **Parameter** `msgType` (string): The network message type.
- **Parameter** `structure` (table): The structure of the network message.

**Example:**
```lua
BaseWars.Net.Register("BaseWars_BuyEntity", { 
uuid = "string",
})
```

---

> ***Located at modules/net/sh_net.lua: Line 76***
```lua
function BaseWars.Net.Read(msgType)
```


Read a network message based on a structure.

- **Parameter** `msgType` (string): The network message type.

**Example:**
```lua
local data = BaseWars.Net.Read("BaseWars_BuyEntity")
local uuid = data.uuid
```

---

> ***Located at modules/net/sh_net.lua: Line 107***
```lua
function BaseWars.Net.Write(msgType, data)
```


Write a network message based on a structure, this is the opposite of BaseWars.Net.Read.

- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.

**Example:**
```lua
BaseWars.Net.Write("BaseWars_BuyEntity", { 
uuid = "some_uuid",
})
```

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 30***
```lua
function BaseWars.SpawnMenu.GenerateUUID(item)
```


Generates a UUID for a given item.

- **Parameter** `item` (table): The item to generate a UUID for.

- **Returns** `string`: The generated UUID.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 65***
```lua
function BaseWars.SpawnMenu.AddUUIDsToShop(categoryTable)
```


Adds UUIDs to the shop's item entries.

- **Parameter** `categoryTable` (table): The table representing the shop's categories.

- **Returns** `table`: The updated category table.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 100***
```lua
function BaseWars.SpawnMenu.CollectItems(categoryTable, depth)
```


Collects all items from the shop's category table, recursively.

- **Parameter** `categoryTable` (table): The table representing the shop's categories.
- **Parameter** `depth` (number): The maximum depth to recurse to.

- **Returns** `table`: A table containing all items from the shop's category table.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 134***
```lua
function BaseWars.FlattenShop()
```


Flattens the shop's category table into a single table containing all items.

- **Returns** `table`: A table containing all items from the shop's category table.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 148***
```lua
function BaseWars.SpawnMenu.GetWeaponAutoBuy(ply)
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 154***
```lua
function Player:GetBuyEntityBlockReason(uuid)
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 167***
```lua
function Player:IsVIP()
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 171***
```lua
function Player:GetIsWeaponAutoBuy()
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 175***
```lua
function Player:GetWeaponAutoBuy()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 49***
```lua
function Faction:GetMembers()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 53***
```lua
function Faction:GetName()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 57***
```lua
function Faction:HasPassword()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 61***
```lua
function Faction:GetPassword()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 65***
```lua
function Faction:GetColor()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 69***
```lua
function Faction:GetIcon()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 73***
```lua
function Faction:GetLeader()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 77***
```lua
function Faction:GetMemberCount()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 83***
```lua
function BaseWars.Faction.GetFactions()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 87***
```lua
function BaseWars.Faction.GetFaction(name)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 91***
```lua
function BaseWars.Faction.GetFactionByMember(ply)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 99***
```lua
function Player:GetFaction()
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 103***
```lua
function Player:IsFriendlyEntity(ent)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 108***
```lua
function BaseWars.Faction.ValidateName(name)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 121***
```lua
function BaseWars.Faction.ValidatePassword(password)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 128***
```lua
function BaseWars.Faction.ValidateColor(color)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 135***
```lua
function BaseWars.Faction.ValidateIcon(icon)
```


No documentation available for now.

---

> ***Located at modules/faction/sh_faction.lua: Line 142***
```lua
function BaseWars.Faction.Exists(name)
```


No documentation available for now.

---

> ***Located at modules/money/sh_money.lua: Line 6***
```lua
function Player:CanAfford(amount)
```


Config


BaseWars.Money.Config = BaseWars.Money.Config or {}

BaseWars.Money.Config.StartAmount = 1000



Player functions

---

> ***Located at modules/money/sh_money.lua: Line 24***
```lua
function Player:GetMoney()
```


No documentation available for now.

---

> ***Located at modules/raid/sh_raid.lua: Line 31***
```lua
function BaseWars.Raid.GetRemainingTime(time, points)
```


No documentation available for now.

---

> ***Located at modules/raid/sh_raid.lua: Line 35***
```lua
function BaseWars.Raid.GetRemainingPoints(time, points)
```


No documentation available for now.

---

> ***Located at modules/level/sh_level.lua: Line 3***
```lua
function Player:GetLevel()
```


No documentation available for now.

---

> ***Located at modules/level/sh_level.lua: Line 7***
```lua
function Player:CanAffordLevel(level)
```


No documentation available for now.

---

> ***Located at modules/level/sh_level.lua: Line 11***
```lua
function Player:GetXP()
```


No documentation available for now.

---

> ***Located at modules/level/sh_level.lua: Line 24***
```lua
function Player:GetXPForLevel(level)
```


No documentation available for now.

---

> ***Located at modules/level/sh_level.lua: Line 28***
```lua
function Player:GetXPForNextLevel()
```


No documentation available for now.

---

> ***Located at modules/level/sh_level.lua: Line 32***
```lua
function Player:GetLevelForXP(xp)
```


No documentation available for now.

---

> ***Located at modules/entities/modules/sh_module.lua: Line 5***
```lua
function BaseWars.Entity.Modules:Add(module)
```


No documentation available for now.

---

> ***Located at modules/entities/modules/sh_module.lua: Line 18***
```lua
function BaseWars.Entity.Modules:Remove(name)
```


No documentation available for now.

---

> ***Located at modules/entities/modules/sh_module.lua: Line 22***
```lua
function BaseWars.Entity.Modules:Get(name)
```


No documentation available for now.

---

### Server-Side Functions

> ***Located at init.lua: Line 66***
```lua
function BaseWars.SequentialDataSaving()
```


No documentation available for now.

---

> ***Located at modules/research/sv_research.lua: Line 3***
```lua
function BaseWars.Research.OpenMenu(ent, ply)
```


No documentation available for now.

---

> ***Located at modules/research/sv_research.lua: Line 11***
```lua
function BaseWars.Research.ResearchModule(ent, moduleName, ply)
```


No documentation available for now.

---

> ***Located at modules/research/sv_research.lua: Line 38***
```lua
function BaseWars.Research.InitializePlayer(ply)
```


No documentation available for now.

---

> ***Located at modules/research/sv_research.lua: Line 44***
```lua
function BaseWars.Research.ApplyEffect(ply, module)
```


No documentation available for now.

---

> ***Located at modules/research/sv_research.lua: Line 52***
```lua
function BaseWars.Research.ApplyAllEffects(ply)
```


No documentation available for now.

---

> ***Located at modules/notify/sv_notify.lua: Line 2***
```lua
function BaseWars.Notify.Send(ply, title, message, color)
```


No documentation available for now.

---

> ***Located at modules/notify/sv_notify.lua: Line 11***
```lua
function BaseWars.Notify.Group(group, title, message, color)
```


No documentation available for now.

---

> ***Located at modules/notify/sv_notify.lua: Line 20***
```lua
function BaseWars.Notify.Faction(faction, title, message, color)
```


No documentation available for now.

---

> ***Located at modules/notify/sv_notify.lua: Line 34***
```lua
function BaseWars.Notify.Broadcast(title, message, color)
```


No documentation available for now.

---

> ***Located at modules/net/sv_net.lua: Line 4***
```lua
function BaseWars.Net.Broadcast(msgType, data)
```


Broadcast a network message to all players.

- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.

---

> ***Located at modules/net/sv_net.lua: Line 19***
```lua
function BaseWars.Net.SendToPlayer(ply, msgType, data)
```


Send a network message to a player.

- **Parameter** `ply` (Player): The player to send the message to.
- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.

---

> ***Located at modules/net/sv_net.lua: Line 37***
```lua
function BaseWars.Net.SendToGroup(group, msgType, data)
```


Send a network message to a group of players.

- **Parameter** `group` (table): The group of players to send the message to.
- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.

---

> ***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 52***
```lua
function BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)
```


Attempts to buy an entity for the player.

- **Parameter** `ply` (Player): The player entity to buy the entity for.
- **Parameter** `uuid` (string): The UUID of the entity to buy.
- **Parameter** `pos` (Vector): The position to spawn the entity at.
- **Parameter** `ang` (Angle): The angle to spawn the entity at.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.

---

> ***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 98***
```lua
function BaseWars.SpawnMenu.CalcPosAndAng(ply, ent)
```


Calculates the position and angle to spawn an entity at based on the player's current view.

- **Parameter** `ply` (Player): The player entity to calculate the position and angle for.
- **Parameter** `uuid` (string): The UUID of the entity to calculate the position and angle for.

- **Returns** `Vector, Angle`: The position and angle to spawn the entity at.

---

> ***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 147***
```lua
function BaseWars.SpawnMenu.SetWeaponForAutoBuy(ply, uuid)
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 148***
```lua
function BaseWars.SpawnMenu.DisableWeaponAutoBuy(ply)
```


No documentation available for now.

---

> ***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 155***
```lua
function BaseWars.SpawnMenu.ActivateWeaponAutoBuy(ply, uuid, state)
```


No documentation available for now.

---

> ***Located at modules/props/sv_props.lua: Line 1***
```lua
function BaseWars.Props.FindPlayerProps(ply)
```


No documentation available for now.

---

> ***Located at modules/faction/sv_faction.lua: Line 6***
```lua
function Faction:SetLeader(leader)
```


Sets the specified player as the leader of the faction.

- **Parameter** `leader` (Player): The player entity to set as the leader of the faction.

---

> ***Located at modules/faction/sv_faction.lua: Line 16***
```lua
function Player:SetFaction(faction)
```


Sets the faction for the player. If a faction object is provided, it uses the faction's name.

- **Parameter** `faction` (string|table): The faction name or faction table to associate with the player.

---

> ***Located at modules/faction/sv_faction.lua: Line 27***
```lua
function BaseWars.Faction.Initialize()
```


Initializes the factions system, ensuring the factions table is set up and synchronizes factions.

---

> ***Located at modules/faction/sv_faction.lua: Line 53***
```lua
function BaseWars.Faction.CreateFaction(name, password, color, icon, leader)
```


Attempts to create a new faction with the provided parameters and sets the leader.

- **Parameter** `name` (string): The unique name of the faction.
- **Parameter** `password` (string): The password for the faction, if any.
- **Parameter** `color` (Color): The color associated with the faction.
- **Parameter** `icon` (string): The icon representing the faction.
- **Parameter** `leader` (Player): The player entity to set as the initial leader of the faction.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.

---

> ***Located at modules/faction/sv_faction.lua: Line 118***
```lua
function BaseWars.Faction.SyncFactions(ply)
```


Synchronizes all faction data with a specific player or all players if no player is specified.

- **Parameter** `ply` (Player): The player to synchronize with. If nil, synchronizes with all players.

---

> ***Located at modules/faction/sv_faction.lua: Line 139***
```lua
function BaseWars.Faction.SyncFaction(factionName, faction)
```


Synchronizes a specific faction's details with all players.

- **Parameter** `faction` (table): The faction table containing faction details to synchronize.

---

> ***Located at modules/faction/sv_faction.lua: Line 158***
```lua
function BaseWars.Faction.JoinFaction(ply, factionName, password)
```


Handles the process of a player attempting to join a faction, including password verification.

- **Parameter** `ply` (Player): The player attempting to join the faction.
- **Parameter** `factionName` (string): The name of the faction the player is attempting to join.
- **Parameter** `password` (string): The password provided by the player for the faction, if required.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.

---

> ***Located at modules/faction/sv_faction.lua: Line 201***
```lua
function BaseWars.Faction.LeaveFaction(ply)
```


Handles the process of a player leaving their current faction.

- **Parameter** `ply` (Player): The player leaving the faction.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.

---

> ***Located at modules/faction/sv_faction.lua: Line 235***
```lua
function BaseWars.Faction.DeleteFaction(name)
```


Deletes a faction with the given name from the server.

- **Parameter** `name` (string): The name of the faction to delete.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.

---

> ***Located at modules/faction/sv_faction.lua: Line 268***
```lua
function BaseWars.Faction.SetFaction(ply, name, leader)
```


Sets the faction for a player directly, optionally setting them as the leader.

- **Parameter** `ply` (Player): The player to set the faction for.
- **Parameter** `name` (string): The name of the faction to set.
@param {boolean} [leader] - Whether the player should also be set as the leader of the faction.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.

---

> ***Located at modules/faction/sv_faction.lua: Line 296***
```lua
function BaseWars.Faction.KickPlayer(ply, target)
```


No documentation available for now.

---

> ***Located at modules/leaderboard/sv_leaderboard.lua: Line 8***
```lua
function BaseWars.Leaderboard.RefreshPage(page)
```


No documentation available for now.

---

> ***Located at modules/leaderboard/sv_leaderboard.lua: Line 14***
```lua
function BaseWars.Leaderboard.Send(ply)
```


No documentation available for now.

---

> ***Located at modules/leaderboard/sv_leaderboard.lua: Line 20***
```lua
function BaseWars.Leaderboard.Refresh()
```


No documentation available for now.

---

> ***Located at modules/leaderboard/sv_leaderboard.lua: Line 32***
```lua
function BaseWars.Leaderboard.Think()
```


No documentation available for now.

---

> ***Located at modules/money/sv_money.lua: Line 3***
```lua
function Player:AddMoney(amount)
```


No documentation available for now.

---

> ***Located at modules/money/sv_money.lua: Line 7***
```lua
function Player:TakeMoney(amount)
```


No documentation available for now.

---

> ***Located at modules/money/sv_money.lua: Line 11***
```lua
function Player:SetMoney(amount)
```


No documentation available for now.

---

> ***Located at modules/money/sv_money.lua: Line 15***
```lua
function Player:GiveMoney(amount)
```


No documentation available for now.

---

> ***Located at modules/raid/sv_raid.lua: Line 175***
```lua
function BaseWars.Raid.StartRaid(factionName, targetName, start)
```


No documentation available for now.

---

> ***Located at modules/level/sv_level.lua: Line 6***
```lua
function Player:SetLevel(level)
```


No documentation available for now.

---

> ***Located at modules/level/sv_level.lua: Line 10***
```lua
function Player:AddLevel(level)
```


No documentation available for now.

---

> ***Located at modules/level/sv_level.lua: Line 14***
```lua
function Player:TakeLevel(level)
```


No documentation available for now.

---

> ***Located at modules/level/sv_level.lua: Line 20***
```lua
function Player:SetXP(xp)
```


No documentation available for now.

---

> ***Located at modules/level/sv_level.lua: Line 24***
```lua
function Player:AddXP(xp)
```


No documentation available for now.

---

> ***Located at modules/level/sv_level.lua: Line 37***
```lua
function Player:TakeXP(xp)
```


No documentation available for now.

---

> ***Located at modules/entities/sv_entities.lua: Line 4***
```lua
function BaseWars.Entities.FindPlayerEntities(ply)
```


Returns all entities owned by a player.

- **Parameter** `ply` (Player): The player to find entities for.

---

> ***Located at modules/entities/sv_entities.lua: Line 22***
```lua
function BaseWars.Entities.SellEntity(ply, ent)
```


Sells an entity for a player.

- **Parameter** `ply` (Player): The player selling the entity.
- **Parameter** `ent` (Entity): The entity being sold.

---

> ***Located at modules/entities/sv_entities.lua: Line 57***
```lua
function BaseWars.Entities.UpgradeEntity(ply, ent)
```


if not ent:CanSell() then
BaseWars.Notify.Send(ply, "You cannot sell this entity!")
return
end

ply:AddMoney(value)
ent:Remove()

BaseWars.Notify.Send(ply, "You sold an entity for " .. value .. "!")
end




Upgrades an entity for a player.

- **Parameter** `ply` (Player): The player upgrading the entity.
- **Parameter** `ent` (Entity): The entity being upgraded.
- **Parameter** `upgrade` (string): The upgrade being applied.

---


## Contributing