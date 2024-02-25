local BW_SPAWNPOINT_MODULE = {}
BW_SPAWNPOINT_MODULE.__index = BW_SPAWNPOINT_MODULE

-- Constants
local MODULE_NAME = "SpawnPoint"
local MODULE_DESC = "Allows a player to set their spawn location."

-- Initialization
function BW_SPAWNPOINT_MODULE.New()
    local self = setmetatable({}, BW_SPAWNPOINT_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC

    return self
end

function BW_SPAWNPOINT_MODULE:Initialize(ent)
    print("SpawnPoint module initialized for entity: ", ent)

    if SERVER then
        local ForceAngle = Angle(-90, 0, 0)
        ent:SetAngles(ForceAngle)
    end
end

function BW_SPAWNPOINT_MODULE:UseFunc(ent, activator, caller)

    local ply = activator:IsPlayer() and activator or caller:IsPlayer() and caller or nil

    if ply then
        ent:EmitSound("buttons/blip1.wav")

        ent.OwningPly = ply
        ply.SpawnPoint = ent

        return true, BaseWars.Lang("ActivatedSpawnpoint")
    end

    ent:EmitSound("buttons/button10.wav")

    return false, BaseWars.Lang("YouMustBeAPlayerToUseThis")
end

function BW_SPAWNPOINT_MODULE:OnRemove(ent)
    if IsValid(ent.OwningPly) then
        ent.OwningPly.SpawnPoint = nil
    end
end

local spawnPointModuleInstance = BW_SPAWNPOINT_MODULE.New()
BaseWars.Entity.Modules:Add(spawnPointModuleInstance)
