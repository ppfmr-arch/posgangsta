SWEP.Category = "sKeypad"
SWEP.Author = "Stromic"
SWEP.PrintName = "EMP Grenade"
SWEP.Slot = 4
SWEP.SlotPos = 24
SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false
SWEP.Weight = 2
SWEP.AutoSwitchTo = true
SWEP.UseHands = true
SWEP.AutoSwitchFrom = true
SWEP.HoldType = "grenade"


SWEP.ViewModelFOV = 60
SWEP.ViewModel = Model("models/weapons/c_grenade.mdl")
SWEP.WorldModel = Model("models/weapons/w_grenade.mdl")
SWEP.ShowWorldModel = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Ammo ="none"

local function beacon(grenade)
	grenade:EmitSound(sKeypad.config.EMPBeaconSound)
	local ePos = grenade:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( ePos )
	util.Effect( "Sparks", effectdata )
end

function SWEP:Throw()
	local tr = self.Owner:GetEyeTrace()

	local pos, ang = LocalToWorld( Vector( -7, -23, 6.5 ), Angle( -50, -95, 175 ), tr.StartPos, tr.Normal:Angle() )

	local grenade = ents.Create("prop_physics")
	grenade:SetModel(self.WorldModel)
	grenade:SetPos(pos)
	grenade:SetCollisionGroup(1)
	grenade:SetAngles(ang)
	grenade:Spawn()

	beacon(grenade)

	timer.Create(grenade:EntIndex().."Beacon", 1, 0, function()
		beacon(grenade)
	end)

	timer.Simple(.1, function()
		if !IsValid(grenade) then return end
		grenade:SetCollisionGroup(0)
	end)

	local phys = grenade:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()

		phys:SetVelocityInstantaneous( self.Owner:GetVelocity() )

		local fw = tr.HitPos - pos
		local dist = fw:Length()
		if ( dist > 0 ) then

			fw:Mul( 750 / dist )

			local up = ang:Up()
			up:Mul( 4 )
			up:Add( pos )

			phys:ApplyForceOffset( fw, up )
		end
	end

	timer.Simple(3, function()
		if !IsValid(grenade) then return end
		timer.Remove(grenade:EntIndex().."Beacon")
		grenade:EmitSound(sKeypad.config.EMPExplosionSound)
		local ePos = grenade:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( ePos )
		util.Effect( "VortDispel", effectdata )

		for k,v in pairs(ents.FindInSphere(grenade:GetPos(), sKeypad.config.empRadius)) do
			if v:GetClass() == "s_keypad" and !v.data.upgrades["emp"] then
				v:AccessGranted()
			end
		end

		grenade:Remove()
	end)
end



function SWEP:PrimaryAttack()
	self.Pullback = true
	self:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
end

function SWEP:Think()
	if SERVER and self.Pullback and !self.Owner:KeyDown(IN_ATTACK) and !self.Throwing then
		local ply = self.Owner
		self.Throwing = true
		self:SendWeaponAnim( ACT_VM_THROW )
		ply:SetAnimation(PLAYER_ATTACK1)
		self:Throw()

		timer.Simple(.5, function()
			ply:StripWeapon("skeypad_emp_grenade")
		end)
	end
end


function SWEP:SecondaryAttack()

end

-- vk.com/urbanichka