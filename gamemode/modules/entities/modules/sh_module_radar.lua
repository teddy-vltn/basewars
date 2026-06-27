local BW_RADAR_MODULE = {}
BW_RADAR_MODULE.__index = BW_RADAR_MODULE

-- Constants
local MODULE_NAME = "Radar"
local MODULE_DESC = "Allows the entity to raidable people and entities"

-- Initialization
function BW_RADAR_MODULE.New()
    local self = setmetatable({}, BW_RADAR_MODULE)
    
    self.Name = MODULE_NAME
    self.Description = MODULE_DESC
    self.NetworkVars = {
        {"RadarCoolDown", 0, "Int"},
        {"RadarRadius", 0, "Int"},
    }

    self.InitializedEntities = self.InitializedEntities or {} -- This will hold the entities initialized with this module
    
    return self
end

function BW_RADAR_MODULE:Initialize(ent)
    self.InitializedEntities[ent] = true -- Mark the entity as initialized

    print("Radar module initialized for entity: ", ent)
end

function BW_RADAR_MODULE:Use(ent, ply)
    local RadarCoolDown = ent:GetRadarCoolDown()
    local RadarRadius = ent:GetRadarRadius()

    if RadarCoolDown > CurTime() then
        return
    end

    --ent:SetRadarCoolDown(CurTime() + 30)

    -- Player:TryOpenRadarMenu( radar )

    if not IsValid(ply) then return end

    BaseWars.Radar.SendRaidableEntities(ply, ent)
end

local radarModule = BW_RADAR_MODULE.New()
BaseWars.Entity.Modules:Add(radarModule)