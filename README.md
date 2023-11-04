# BaseWars 

## Description

## Installation

## Documentation
### Client Side Functions

```
function BaseWars.Net.SendToServer(msgType, data)
```
```
function Player:BuyEntity(uuid)
```
```
function Player:SetAutoBuy(bool, weapon)
```
```
function BaseWars.Faction.TryJoinFaction(name, password)
```
```
function BaseWars.Faction.TryLeaveFaction(name)
```
```
function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
```
### Shared Side Functions

```
function BaseWars.RegisterModule(name, dependencies, path, prefix)
```
```
function BaseWars.IncludeModules()
```
```
function BaseWars.RegisterModuleFolder(folder, dependencies)
```
```
function BaseWars.Net.Register(msgType, structure)
```
```
function BaseWars.Net.Read(msgType)
```
```
function BaseWars.Net.Write(msgType, data)
```
```
function BaseWars.SpawnMenu.GenerateUUID(item)
```
```
function BaseWars.SpawnMenu.AddUUIDsToShop(categoryTable)
```
```
function BaseWars.SpawnMenu.CollectItems(categoryTable, depth)
```
```
function BaseWars.FlattenShop()
```
```
function BaseWars.SpawnMenu.GetWeaponAutoBuy(ply)
```
```
function Player:GetBuyEntityBlockReason(uuid)
```
```
function Player:IsVIP()
```
```
function BaseWars.Faction.GetFactions()
```
```
function BaseWars.Faction.GetFaction(name)
```
```
function BaseWars.Faction.GetFactionByMember(ply)
```
```
function Player:GetFaction()
```
```
function Player:IsFriendlyEntity(ent)
```
```
function Player:CanAfford(amount)
```
```
function Player:GetMoney()
```
```
function BaseWars.Raid.new(attackingFaction, defendingFaction)
```
```
function BaseWars.Raid:CheckProgress()
```
```
function Player:GetLevel()
```
```
function Player:CanAffordLevel(level)
```
```
function Player:GetXP()
```
```
function Player:GetXPForLevel(level)
```
```
function Player:GetXPForNextLevel()
```
```
function Player:GetLevelForXP(xp)
```
```
function BaseWars.Entity.Modules:Add(module)
```
```
function BaseWars.Entity.Modules:Remove(name)
```
```
function BaseWars.Entity.Modules:Get(name)
```
### Server Side Functions

```
function BaseWars.Notify.Send(ply, title, message, color)
```
```
function BaseWars.Notify.Broadcast(title, message, color)
```
```
function BaseWars.Net.Broadcast(msgType, data)
```
```
function BaseWars.Net.SendToPlayer(ply, msgType, data)
```
```
function BaseWars.Net.SendToGroup(group, msgType, data)
```
```
function BaseWars.SpawnMenu.BuyEntity(ply, uuid, pos, ang)
```
```
function BaseWars.SpawnMenu.CalcPosAndAng(ply, ent)
```
```
function BaseWars.SpawnMenu.DisableWeaponAutoBuy(ply)
```
```
function BaseWars.SpawnMenu.ActivateWeaponAutoBuy(ply, uuid, state)
```
```
function Player:SaveData()
```
```
function Player:LoadData()
```
```
function BaseWars.Props.FindPlayerProps(ply)
```
```
function Player:SetFaction(faction)
```
```
function BaseWars.Faction.Initialize() -- Initialisation
```
```
function BaseWars.Faction.CreateFaction(name, password, color, icon, leader)
```
```
function BaseWars.Faction.SyncFactions(ply)
```
```
function BaseWars.Faction.SyncFaction(faction)
```
```
function BaseWars.Faction.JoinFaction(ply, factionName, password)
```
```
function BaseWars.Faction.LeaveFaction(ply)
```
```
function BaseWars.Faction.DeleteFaction(name)
```
```
function BaseWars.Faction.SetFaction(ply, name, leader)
```
```
function Player:AddMoney(amount)
```
```
function Player:TakeMoney(amount)
```
```
function Player:SetMoney(amount)
```
```
function Player:GiveMoney(amount)
```
```
function BaseWars.Raiding.CanInitiateRaid(faction)
```
```
function BaseWars.Raiding.SetCooldown(faction, time)
```
```
function BaseWars.Raiding.StartRaid(attackingPlayer, defendingFactionName)
```
```
function BaseWars.Raiding.UpdateRaidProgress()
```
```
function BaseWars.Raiding.EndRaid(winnerFaction)
```
```
function Player:SetLevel(level)
```
```
function Player:AddLevel(level)
```
```
function Player:TakeLevel(level)
```
```
function Player:SetXP(xp)
```
```
function Player:AddXP(xp)
```
```
function Player:TakeXP(xp)
```
```
function BaseWars.Entities.FindPlayerEntities(ply)
```
## Contributing