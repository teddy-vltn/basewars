# BaseWars 

## Description

## Installation

## Documentation
```
function BaseWars.LoadEntityConfiguration()
```
```
function BaseWars.NumberFormat(n)
```
```
function BaseWars.Notify.Send(ply, title, message, color)
```
```
function BaseWars.Notify.Broadcast(title, message, color)
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
function BaseWars.Faction.TryJoinFaction(name, password)
```
```
function BaseWars.Faction.TryLeaveFaction(name)
```
```
function BaseWars.Faction.TryCreateFaction(name, password, color, icon)
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
function BaseWars.Faction.HasFactionPassword(name)
```
```
function BaseWars.Faction.Initialize() -- Initialisation
```
```
function BaseWars.Faction.CreateFaction(name, leader, password, color, icon)
```
```
function BaseWars.Faction.SyncFactions(ply)
```
```
function BaseWars.Faction.SyncFaction(name, factionTable) -- Synchronisation
```
```
function BaseWars.Faction.JoinFaction(ply, name, password)
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
function BaseWars.Entity.Modules:Add(module)
```
```
function BaseWars.Entity.Modules:Remove(name)
```
```
function BaseWars.Entity.Modules:Get(name)
```
## Contributing