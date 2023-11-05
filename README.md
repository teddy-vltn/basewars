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

***Located at modules/net/cl_net.lua: Line 4***
```lua
function BaseWars.Net.SendToServer(msgType, data)
```
Send a network message to the server.

- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.
---

***Located at modules/spawnmenu/cl_spawnmenu.lua: Line 6***
```lua
function Player:BuyEntity(uuid)
```
No documentation available for now.
---

***Located at modules/spawnmenu/cl_spawnmenu.lua: Line 12***
```lua
function Player:SetAutoBuy(bool, weapon)
```
No documentation available for now.
---

***Located at modules/faction/cl_faction.lua: Line 58***
```lua
function BaseWars.Faction.TryJoinFaction(name, password)
```
No documentation available for now.
---

***Located at modules/faction/cl_faction.lua: Line 62***
```lua
function BaseWars.Faction.TryLeaveFaction(name)
```
No documentation available for now.
---

***Located at modules/faction/cl_faction.lua: Line 66***
```lua
function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
```
No documentation available for now.
---

### Shared-Side Functions

***Located at modules/sh_modules.lua: Line 7***
```lua
function BaseWars.RegisterModule(name, dependencies, path, prefix)
```
No documentation available for now.
---

***Located at modules/sh_modules.lua: Line 52***
```lua
function BaseWars.IncludeModules()
```
No documentation available for now.
---

***Located at modules/sh_modules.lua: Line 64***
```lua
function BaseWars.RegisterModuleFolder(folder, dependencies)
```
No documentation available for now.
---

***Located at modules/net/sh_net.lua: Line 50***
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

***Located at modules/net/sh_net.lua: Line 75***
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

***Located at modules/net/sh_net.lua: Line 106***
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

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 32***
```lua
function BaseWars.SpawnMenu.GenerateUUID(item)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 61***
```lua
function BaseWars.SpawnMenu.AddUUIDsToShop(categoryTable)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 90***
```lua
function BaseWars.SpawnMenu.CollectItems(categoryTable, depth)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 117***
```lua
function BaseWars.FlattenShop()
```
No documentation available for now.
---

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 125***
```lua
function BaseWars.SpawnMenu.GetWeaponAutoBuy(ply)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 131***
```lua
function Player:GetBuyEntityBlockReason(uuid)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sh_spawnmenu.lua: Line 144***
```lua
function Player:IsVIP()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 47***
```lua
function Faction:GetMembers()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 51***
```lua
function Faction:GetName()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 55***
```lua
function Faction:HasPassword()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 59***
```lua
function Faction:GetPassword()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 63***
```lua
function Faction:GetColor()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 67***
```lua
function Faction:GetIcon()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 71***
```lua
function Faction:GetLeader()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 75***
```lua
function Faction:GetMemberCount()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 81***
```lua
function BaseWars.Faction.GetFactions()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 85***
```lua
function BaseWars.Faction.GetFaction(name)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 89***
```lua
function BaseWars.Faction.GetFactionByMember(ply)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 97***
```lua
function Player:GetFaction()
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 101***
```lua
function Player:IsFriendlyEntity(ent)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 106***
```lua
function BaseWars.Faction.ValidateName(name)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 119***
```lua
function BaseWars.Faction.ValidatePassword(password)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 126***
```lua
function BaseWars.Faction.ValidateColor(color)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 133***
```lua
function BaseWars.Faction.ValidateIcon(icon)
```
No documentation available for now.
---

***Located at modules/faction/sh_faction.lua: Line 140***
```lua
function BaseWars.Faction.Exists(name)
```
No documentation available for now.
---

***Located at modules/money/sh_money.lua: Line 6***
```lua
function Player:CanAfford(amount)
```
Config


BaseWars.Money.Config = BaseWars.Money.Config or {}

BaseWars.Money.Config.StartAmount = 1000



Player functions
---

***Located at modules/money/sh_money.lua: Line 24***
```lua
function Player:GetMoney()
```
No documentation available for now.
---

***Located at modules/raid/sh_raid.lua: Line 30***
```lua
function BaseWars.Raid.GetRemainingTime(time, points)
```
No documentation available for now.
---

***Located at modules/raid/sh_raid.lua: Line 34***
```lua
function BaseWars.Raid.GetRemainingPoints(time, points)
```
No documentation available for now.
---

***Located at modules/level/sh_level.lua: Line 3***
```lua
function Player:GetLevel()
```
No documentation available for now.
---

***Located at modules/level/sh_level.lua: Line 7***
```lua
function Player:CanAffordLevel(level)
```
No documentation available for now.
---

***Located at modules/level/sh_level.lua: Line 11***
```lua
function Player:GetXP()
```
No documentation available for now.
---

***Located at modules/level/sh_level.lua: Line 24***
```lua
function Player:GetXPForLevel(level)
```
No documentation available for now.
---

***Located at modules/level/sh_level.lua: Line 28***
```lua
function Player:GetXPForNextLevel()
```
No documentation available for now.
---

***Located at modules/level/sh_level.lua: Line 32***
```lua
function Player:GetLevelForXP(xp)
```
No documentation available for now.
---

***Located at modules/entities/modules/sh_module.lua: Line 5***
```lua
function BaseWars.Entity.Modules:Add(module)
```
No documentation available for now.
---

***Located at modules/entities/modules/sh_module.lua: Line 18***
```lua
function BaseWars.Entity.Modules:Remove(name)
```
No documentation available for now.
---

***Located at modules/entities/modules/sh_module.lua: Line 22***
```lua
function BaseWars.Entity.Modules:Get(name)
```
No documentation available for now.
---

### Server-Side Functions

***Located at modules/notify/sv_notify.lua: Line 2***
```lua
function BaseWars.Notify.Send(ply, title, message, color)
```
No documentation available for now.
---

***Located at modules/notify/sv_notify.lua: Line 11***
```lua
function BaseWars.Notify.Group(group, title, message, color)
```
No documentation available for now.
---

***Located at modules/notify/sv_notify.lua: Line 20***
```lua
function BaseWars.Notify.Faction(faction, title, message, color)
```
No documentation available for now.
---

***Located at modules/notify/sv_notify.lua: Line 34***
```lua
function BaseWars.Notify.Broadcast(title, message, color)
```
No documentation available for now.
---

***Located at modules/net/sv_net.lua: Line 4***
```lua
function BaseWars.Net.Broadcast(msgType, data)
```
Broadcast a network message to all players.

- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.
---

***Located at modules/net/sv_net.lua: Line 17***
```lua
function BaseWars.Net.SendToPlayer(ply, msgType, data)
```
Send a network message to a player.

- **Parameter** `ply` (Player): The player to send the message to.
- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.
---

***Located at modules/net/sv_net.lua: Line 33***
```lua
function BaseWars.Net.SendToGroup(group, msgType, data)
```
Send a network message to a group of players.

- **Parameter** `group` (table): The group of players to send the message to.
- **Parameter** `msgType` (string): The network message type.
- **Parameter** `data` (table): The data to send.
---

***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 45***
```lua
function BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 81***
```lua
function BaseWars.SpawnMenu.CalcPosAndAng(ply, ent)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 121***
```lua
function BaseWars.SpawnMenu.SetWeaponForAutoBuy(ply, uuid)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 122***
```lua
function BaseWars.SpawnMenu.DisableWeaponAutoBuy(ply)
```
No documentation available for now.
---

***Located at modules/spawnmenu/sv_spawnmenu.lua: Line 129***
```lua
function BaseWars.SpawnMenu.ActivateWeaponAutoBuy(ply, uuid, state)
```
No documentation available for now.
---

***Located at modules/persistent/sv_persistent.lua: Line 5***
```lua
function Player:SaveData()
```
No documentation available for now.
---

***Located at modules/persistent/sv_persistent.lua: Line 13***
```lua
function Player:LoadData()
```
No documentation available for now.
---

***Located at modules/props/sv_props.lua: Line 1***
```lua
function BaseWars.Props.FindPlayerProps(ply)
```
No documentation available for now.
---

***Located at modules/faction/sv_faction.lua: Line 6***
```lua
function Faction:SetLeader(leader)
```
Sets the specified player as the leader of the faction.

- **Parameter** `leader` (Player): The player entity to set as the leader of the faction.
---

***Located at modules/faction/sv_faction.lua: Line 16***
```lua
function Player:SetFaction(faction)
```
Sets the faction for the player. If a faction object is provided, it uses the faction's name.

- **Parameter** `faction` (string|table): The faction name or faction table to associate with the player.
---

***Located at modules/faction/sv_faction.lua: Line 27***
```lua
function BaseWars.Faction.Initialize()
```
Initializes the factions system, ensuring the factions table is set up and synchronizes factions.
---

***Located at modules/faction/sv_faction.lua: Line 53***
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

***Located at modules/faction/sv_faction.lua: Line 112***
```lua
function BaseWars.Faction.SyncFactions(ply)
```
Synchronizes all faction data with a specific player or all players if no player is specified.

- **Parameter** `ply` (Player): The player to synchronize with. If nil, synchronizes with all players.
---

***Located at modules/faction/sv_faction.lua: Line 133***
```lua
function BaseWars.Faction.SyncFaction(faction)
```
Synchronizes a specific faction's details with all players.

- **Parameter** `faction` (table): The faction table containing faction details to synchronize.
---

***Located at modules/faction/sv_faction.lua: Line 150***
```lua
function BaseWars.Faction.JoinFaction(ply, factionName, password)
```
Handles the process of a player attempting to join a faction, including password verification.

- **Parameter** `ply` (Player): The player attempting to join the faction.
- **Parameter** `factionName` (string): The name of the faction the player is attempting to join.
- **Parameter** `password` (string): The password provided by the player for the faction, if required.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.
---

***Located at modules/faction/sv_faction.lua: Line 193***
```lua
function BaseWars.Faction.LeaveFaction(ply)
```
Handles the process of a player leaving their current faction.

- **Parameter** `ply` (Player): The player leaving the faction.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.
---

***Located at modules/faction/sv_faction.lua: Line 218***
```lua
function BaseWars.Faction.DeleteFaction(name)
```
Deletes a faction with the given name from the server.

- **Parameter** `name` (string): The name of the faction to delete.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.
---

***Located at modules/faction/sv_faction.lua: Line 251***
```lua
function BaseWars.Faction.SetFaction(ply, name, leader)
```
Sets the faction for a player directly, optionally setting them as the leader.

- **Parameter** `ply` (Player): The player to set the faction for.
- **Parameter** `name` (string): The name of the faction to set.
@param {boolean} [leader] - Whether the player should also be set as the leader of the faction.

- **Returns** `boolean, string`: A status indicating success or failure, and a message explaining the result.
---

***Located at modules/money/sv_money.lua: Line 3***
```lua
function Player:AddMoney(amount)
```
No documentation available for now.
---

***Located at modules/money/sv_money.lua: Line 7***
```lua
function Player:TakeMoney(amount)
```
No documentation available for now.
---

***Located at modules/money/sv_money.lua: Line 11***
```lua
function Player:SetMoney(amount)
```
No documentation available for now.
---

***Located at modules/money/sv_money.lua: Line 15***
```lua
function Player:GiveMoney(amount)
```
No documentation available for now.
---

***Located at modules/raid/sv_raid.lua: Line 163***
```lua
function BaseWars.Raid.StartRaid(factionName, targetName, start)
```
No documentation available for now.
---

***Located at modules/level/sv_level.lua: Line 6***
```lua
function Player:SetLevel(level)
```
No documentation available for now.
---

***Located at modules/level/sv_level.lua: Line 10***
```lua
function Player:AddLevel(level)
```
No documentation available for now.
---

***Located at modules/level/sv_level.lua: Line 14***
```lua
function Player:TakeLevel(level)
```
No documentation available for now.
---

***Located at modules/level/sv_level.lua: Line 20***
```lua
function Player:SetXP(xp)
```
No documentation available for now.
---

***Located at modules/level/sv_level.lua: Line 24***
```lua
function Player:AddXP(xp)
```
No documentation available for now.
---

***Located at modules/level/sv_level.lua: Line 37***
```lua
function Player:TakeXP(xp)
```
No documentation available for now.
---

***Located at modules/entities/sv_entities.lua: Line 4***
```lua
function BaseWars.Entities.FindPlayerEntities(ply)
```
No documentation available for now.
---


## Contributing