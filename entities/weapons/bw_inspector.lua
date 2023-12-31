SWEP.PrintName = "The Inspector"
SWEP.Author = "Teddy"
SWEP.Purpose = "Inspect entities and open context menus"
SWEP.Spawnable = false

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Primary.Delay = 1 
function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    -- Play swing animation
    self:SendWeaponAnim(ACT_VM_HITCENTER)

    local trace = ply:GetEyeTrace()
    if IsValid(trace.Entity) then
        self:OpenMenuForEntity(trace.Entity)
    end
end

function SWEP:ViewModelDrawn()
    local viewModel = self.Owner:GetViewModel()
    -- color the viewmodel
    viewModel:SetColor(Color(0, 255, 0, 255))
end

function SWEP:OpenMenuForEntity(entity)
    if CLIENT then
        -- Implementation of the context menu based on the entity
    end
end
