--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

--[[
Stun gun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
]]

STUNGUN = {} -- General stungun stuff table

STUNGUN.IsDarkRP = ((type(DarkRP) == "table") or (RPExtraTeams != nil))
STUNGUN.IsDarkRP25 = (STUNGUN.IsDarkRP and (type(DarkRP) == "table") and DarkRP.getPhrase)
STUNGUN.IsTTT = ((ROLE_TRAITOR != nil) and (ROLE_INNOCENT != nil) and (ROLE_DETECTIVE != nil) and (GetRoundState != nil)) -- For a gamemode to be TTT, these should probably exist.

include("config.lua")

if STUNGUN.IsTTT then
	SWEP.Base = "weapon_tttbase"
	SWEP.AmmoEnt = ""
	SWEP.IsSilent = false
	SWEP.NoSights = true
end

SWEP.Author = "Donkie"
SWEP.Instructions = string.format("Left click to stun a person.%s", STUNGUN.CanUntaze and "\nRight click to unstun a person." or "")
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/freeman/c_taser_x26.mdl")
SWEP.WorldModel = Model("models/freeman/w_taser_x26.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ammo_stungun"
if STUNGUN.IsTTT and not SWEP.InfiniteAmmo then
	SWEP.Primary.ClipMax = SWEP.Ammo
end

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IsDeployed = false

SWEP.DeployTime = 0.3 -- How many seconds it takes to deploy the weapon

sound.Add(
{
	name = "taserx26.cartout",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 90,
	sound = "freeman/taserx26_click1.wav"
})

sound.Add(
{
	name = "taserx26.cartin",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 90,
	sound = "freeman/taserx26_click2.wav"
})

game.AddAmmoType({
	name = "ammo_stungun",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
})

if STUNGUN.AddAmmoItem >= 0 then
	if DarkRP and DarkRP.createAmmoType then
		DarkRP.createAmmoType("ammo_stungun", {
			name = "Stun gun Charge",
			model = "models/freeman/taserx26_cartridge.mdl",
			price = math.ceil(STUNGUN.AddAmmoItem),
			amountGiven = 1
		})
	elseif GAMEMODE.AddAmmoType then
		GAMEMODE:AddAmmoType("ammo_stungun", "Stun gun Charge", "models/freeman/taserx26_cartridge.mdl", math.ceil(STUNGUN.AddAmmoItem), 1)
	end
end

function SWEP:Initialize()
	self.ChargeInserted = self:Clip1Custom() >= 1
	self.IsCharged = (self:Clip1Custom() >= 1 and (self.StartCharged or (self.Charge and self.Charge > 0))) -- self.Charge is for config backwards compatibility
end

function SWEP:DoEffect(tr)
	-- Animations
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	-- Electric bolt
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetEntity(self)
	util.Effect("stungun_trace", effectdata)
end

local rangeSqr = SWEP.Range * SWEP.Range
function SWEP:PrimaryAttack()
	if not self.ChargeInserted or not self.IsCharged then return end

	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		if self:Clip1Custom() <= 0 then return end
		self:SetClip1Custom(self:Clip1Custom() - 1)
	end

	-- Shoot trace
	self.Owner:LagCompensation(true)
	local tr = util.TraceLine(util.GetPlayerTrace(self.Owner))
	self.Owner:LagCompensation(false)

	self:DoEffect(tr)

	self.IsCharged = false

	if SERVER then
		self.Owner:EmitSound("npc/turret_floor/shoot1.wav",100,100)
	end

	local ent = tr.Entity

	if CLIENT then return end

	-- Don't proceed if we don't hit any player
	if not IsValid(ent) or not ent:IsPlayer() then return end
	if ent == self.Owner then return end
	if IsValid(ent.tazeragdoll) or ent:GetNWBool("tazefrozen", false) then return end
	if self.Owner:GetShootPos():DistToSqr(tr.HitPos) > rangeSqr then return end

	local canTaze = hook.Run("PlayerCanTaze", self.Owner, ent)
	if canTaze == false then return end -- Someone want it to be prevented

	if canTaze != true and (
		ent.tazeimmune or -- Was recently tazed
		STUNGUN.IsPlayerImmune(ent) or -- Custom immunity function, e.g. immune teams
		(not STUNGUN.AllowFriendlyFire and STUNGUN.SameTeam(self.Owner, ent))
	) then -- Attacker and victim on same team
		return
	end
	if math.random(1, 100) > (STUNGUN.SuccessChance or 100) then return end

	-- Drop weapon
	if STUNGUN.DropWeaponOnTaze then
		STUNGUN.DropActiveWeapon(ent)
	end

	-- Damage
	if (STUNGUN.StunDamage and STUNGUN.StunDamage > 0) and not ent.tazeimmune then
		local dmginfo = DamageInfo()
			dmginfo:SetDamage(STUNGUN.StunDamage)
			dmginfo:SetAttacker(self.Owner)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamageType(DMG_SHOCK)
			dmginfo:SetDamagePosition(tr.HitPos)
			dmginfo:SetDamageForce(self.Owner:GetAimVector() * 30)
		ent:TakeDamageInfo(dmginfo)
	end

	--The player might have died while getting tazed
	if ent:Alive() then
		hook.Run("PlayerTazed", ent, self.Owner)

		-- Electrocute the player
		STUNGUN.Electrocute( ent, (ent:GetPos() - self.Owner:GetPos()):GetNormal() )
	end
end

function SWEP:SetCartridgeVisible(visible)
	local vm = self.Owner:GetViewModel()
	if not IsValid(vm) then return end

	if not self.bodygroupId then self.bodygroupId = vm:FindBodygroupByName("cartridge") end
	vm:SetBodygroup(self.bodygroupId, visible and 1 or 0)
end

function SWEP:SetCartridgeVisibleWorld(visible)
	if not self.bodygroupId then self.bodygroupId = self:FindBodygroupByName("cartridge") end
	self:SetBodygroup(self.bodygroupId, visible and 1 or 0)
end

function SWEP:GetCharge()
	if not self.ChargeInserted or self:Clip1Custom() <= 0 then return 0 end
	if self.IsCharged then return 1 end
	if not self.ChargedAt then return 0 end

	return math.Clamp(1 - (self.ChargedAt - CurTime()) / self.RechargeTime, 0, 1)
end

if CLIENT then
	-- These are not properly predicted. The client forgets the set clip after a tick which causes desyncing in the animations.
	function SWEP:SetClip1Custom(am)
		if CLIENT and not IsFirstTimePredicted() then return end
		if am == self:Clip1() then return end

		self.clip1override = am
		self:SetClip1(am)
	end
	function SWEP:Clip1Custom()
		if self.clip1override then
			return self.clip1override
		end

		return self:Clip1()
	end
	function SWEP:Clip1ClearOverride()
		self.clip1override = nil
	end
else
	function SWEP:SetClip1Custom(am)
		self:SetClip1(am)
	end
	function SWEP:Clip1Custom()
		return self:Clip1()
	end
	function SWEP:Clip1ClearOverride()
	end
end

function SWEP:OwnerHasAmmo()
	return self.InfiniteAmmo or self:Ammo1() > 0
end

function SWEP:AnimThink()
	local curtime = CurTime()

	if self.AnimDeploy and self.AnimDeploy < curtime then
		self.AnimDeploy = nil
		self.IsDeployed = true
	end

	if self.ChargedAt and self.ChargedAt < curtime then
		self.ChargedAt = nil
		self.IsCharged = true
	end

	if not self:IsDeploying() then
		if self.ChargeInserted then
			if self:Clip1Custom() >= 1 and not self.ChargedAt and not self.IsCharged then
				-- Charge inserted, we have clip but it's not marked as charged. Charge it.
				self.ChargedAt = curtime + self.RechargeTime
			end

			if self.AnimReloadingCharge and self.AnimReloadingCharge < curtime then
				-- Triggered when any reloading animation is finished
				self.AnimReloadingCharge = nil

				self:SendWeaponAnim(ACT_VM_IDLE)
				self:SetCartridgeVisible(true)
				self:Clip1ClearOverride() -- Animations done, we can safely clear the override now
			end

			if self.AnimChargeRemoved and self.AnimChargeRemoved < curtime then
				-- Triggered when the charge has been removed from the gun in any reloading animation
				self.AnimChargeRemoved = nil
				self.ChargeInserted = false
				self:SetCartridgeVisibleWorld(false)
			elseif not self.AnimChargeRemoved and not self.AnimChargeRemoveWait and self:Clip1Custom() <= 0 then
				-- We have a charge in the weapon but our clip is empty, that means we have just fired the weapon. Wait a little bit for attack anim to finish then remove the cartridge
				self.AnimChargeRemoveWait = curtime + 0.7
			elseif self.AnimChargeRemoveWait and self.AnimChargeRemoveWait < curtime then
				self.AnimChargeRemoveWait = nil
				self:ReloadCartridge()
			end
		else
			-- Charge not inserted
			if self:Clip1Custom() >= 1 then
				-- Charge not inserted but we still have clip somehow, shouldn't happen but this will fix it
				self.ChargeInserted = true
				self.ChargedAt = curtime + self.RechargeTime
				self:SetCartridgeVisible(true)
				self:SetCartridgeVisibleWorld(true)
			else
				if not self.AnimReloadingCharge and self:OwnerHasAmmo() then
					-- Charge not inserted, we have ammo in our pocket but we're not currently reloading.
					self.AnimReloadingCharge = curtime + (115 / 30)
					self.AnimChargeInserted = curtime + (83 / 30)
					self:SendWeaponAnim(ACT_VM_DRAW)
					self:SetCartridgeVisible(true)
					self.Owner:SetAnimation(PLAYER_RELOAD)
				elseif self.AnimChargeInserted and self.AnimChargeInserted < curtime then
					-- Triggered when the charge has been inserted into the gun
					self.AnimChargeInserted = nil

					if self:CanReloadClip() then
						self:ReloadClip()
						self.ChargeInserted = true
						self.ChargedAt = curtime + self.RechargeTime
						self:SetCartridgeVisibleWorld(true)
					end
				elseif self.AnimUnloadingCharge and self.AnimUnloadingCharge < curtime then
					-- Triggered when the unloading animation is finished
					self.AnimUnloadingCharge = nil

					self:SendWeaponAnim(ACT_VM_IDLE)
					self:SetCartridgeVisible(false)
					self:Clip1ClearOverride() -- Animations done, we can safely clear the override now
				end
			end
		end
	end
end

function SWEP:Think()
	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		self:AnimThink()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:FailAttack()
	self:SetNextSecondaryFire(CurTime() + 0.5)
	self.Owner:EmitSound("Weapon_Pistol.Empty")
end

function SWEP:SecondaryAttack()
	if not STUNGUN.CanUntaze then return end

	if self:GetNextSecondaryFire() >= CurTime() then self:FailAttack() return end

	-- Shoot trace
	self.Owner:LagCompensation(true)
	local tr = util.TraceLine(util.GetPlayerTrace( self.Owner ))
	self.Owner:LagCompensation(false)

	local ent = tr.Entity

	if self.Owner:GetShootPos():DistToSqr(tr.HitPos) > rangeSqr then self:FailAttack() return end

	if CLIENT then return end

	-- Don't proceed if we don't hit any raggy
	local hitRag = IsValid(ent) and ent:GetClass() == "prop_ragdoll" and IsValid(ent.tazeplayer)
	local hitFrozenPlayer = not hitRag and IsValid(ent) and ent:IsPlayer() and ent:GetNWBool("tazefrozen", false)
	if not hitRag and not hitFrozenPlayer then self:FailAttack() return end

	local ply = hitRag and ent.tazeplayer or ent
	local canUnTaze = hook.Run("PlayerCanUnTaze", self.Owner, ply)
	if canUnTaze == false then self:FailAttack() return end

	self:DoEffect(tr)

	self.Owner:EmitSound("npc/turret_floor/shoot1.wav",100,100)

	timer.Simple(.4, function()
		if IsValid(ply) then
			ply:EmitSound("items/smallmedkit1.wav",100,100)
		end
	end)

	hook.Run("PlayerPreUnTazed", ply, self.Owner)

	STUNGUN.UnMute(ply)
	if STUNGUN.IsRagdolled(ply) then
		STUNGUN.UnElectrocute(ply)
	else
		STUNGUN.UnFreeze(ply)
	end

	self:SetNextSecondaryFire(CurTime() + 2)
end

function SWEP:IsDeploying()
	return self.AnimDeploy and self.AnimDeploy > CurTime()
end

function SWEP:Deploy()
	self.AnimReloadingCharge = nil
	self.AnimUnloadingCharge = nil
	self.AnimChargeRemoved = nil
	self.AnimChargeRemoveWait = nil
	self.AnimChargeInserted = nil
	self.AnimDeploy = CurTime() + self.DeployTime

	self:SendWeaponAnim(ACT_VM_IDLE)
	self:NextThink(CurTime())

	timer.Simple(0, function()
		if not IsValid(self) or not IsValid(self.Owner) then return end

		self:SetCartridgeVisible(self.ChargeInserted)
		self:SetCartridgeVisibleWorld(self.ChargeInserted)
	end)
	return true
end

function SWEP:Holster()
	self.IsDeployed = false

	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:CanReloadClip()
	return self:Clip1Custom() <= 0 and self:OwnerHasAmmo()
end

function SWEP:ReloadClip()
	self:SetClip1Custom(1)
	self.Owner:RemoveAmmo(1, "ammo_stungun")
end

function SWEP:ReloadCartridge()
	if self:Clip1Custom() >= 1 then return end
	if CLIENT and not IsFirstTimePredicted() then return end

	self.AnimChargeRemoved = CurTime() + (22 / 30)
	self:SetCartridgeVisible(true)

	self.Owner:SetAnimation(PLAYER_RELOAD)

	if self:OwnerHasAmmo() then
		self:SendWeaponAnim(ACT_VM_RELOAD)
		self.AnimReloadingCharge = CurTime() + (130 / 30)
		self.AnimChargeInserted = CurTime() + (98 / 30)
	else
		self:SendWeaponAnim(ACT_VM_HOLSTER)
		self.AnimUnloadingCharge = CurTime() + (100 / 30)
	end
end

-- No default reloading, we handle that ourselves
function SWEP:Reload()
	return true
end

local shoulddisable = {} -- Disables muzzleflashes and ejections
shoulddisable[21] = true
shoulddisable[5003] = true
shoulddisable[6001] = true
function SWEP:FireAnimationEvent( pos, ang, event, options )
	if shoulddisable[event] then return true end
end

hook.Add("PhysgunPickup", "Tazer", function(_,ent)
	if not STUNGUN.AllowPhysgun and IsValid(ent:GetNWEntity("plyowner")) then return false end
end)
hook.Add("CanTool", "Tazer", function(_,tr,_)
	if not STUNGUN.AllowToolgun and IsValid(tr.Entity) and IsValid(tr.Entity:GetNWEntity("plyowner")) then return false end
end)

hook.Add("StartCommand", "Tazer", function(ply, cmd)
	if ply:GetNWBool("tazefrozen", false) == false then return end

	cmd:ClearMovement()
	cmd:RemoveKey(IN_ATTACK)
	cmd:RemoveKey(IN_ATTACK2)
	cmd:RemoveKey(IN_RELOAD)
	cmd:RemoveKey(IN_USE)
	cmd:RemoveKey(IN_DUCK)
	cmd:RemoveKey(IN_JUMP)
end)

--[[
pLogs-2
]]
local function InitpLogs()
	if not plogs or not plogs.Version or not plogs.Register then return end
	local versionstr = plogs.Version
	local versiontbl = string.Explode(".", versionstr)
	if #versiontbl != 3 then return end

	local major = tonumber(versiontbl[1])
	local minor = tonumber(versiontbl[2])
	-- local patch = tonumber(versiontbl[3])

	if major < 2 or (major == 2 and minor < 7) then
		MsgN("[STUNGUN] pLogs detected but its version is too old!")
		return
	end

	plogs.Register("Stungun", true, Color(255,163,0))

	if SERVER then
		include("sv_plogs.lua")
	end

	MsgN("[STUNGUN] pLogs detected.")
end

if plogs then
	InitpLogs()
else
	hook.Add("Initialize","stungun_waitforplogs",InitpLogs)
end

--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600