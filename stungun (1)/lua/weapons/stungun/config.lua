--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

--[[
Stun gun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
]]

--[[
GENERAL INFORMATION

Weaponclass: "stungun"
Ammotype: "ammo_stungun"
The stun gun is only being tested on Sandbox, DarkRP (latest) and TTT (latest) before releases.
]]

--[[
CONFIG FILE
ONLY EDIT STUFF IN HERE
ANY EDITS OUTSIDE THIS FILE IS NOT MY RESPONSIBILITY
]]

--[[****************
BASIC SECTION
*****************]]

--[[
How it works:

1. A player becomes ragdolled for "STUNGUN.ParalyzedTime" seconds, and muted/gagged for "STUNGUN.MuteTime" seconds after he's been hit with the stungun
2. Once "STUNGUN.ParalyzedTime" seconds has passed, the player becomes un-ragdolled and then frozen instead for "STUNGUN.FreezeTime" seconds
3. Once "STUNGUN.FreezeTime" seconds has passed, the player can move again like normal. The player now becomes immune against the stungun for "STUNGUN.Immunity" seconds.

If you want only ragdolling and not frozen, set "STUNGUN.ParalyzedTime" to what you want, and "STUNGUN.FreezeTime" to 0
If you want only frozen and not ragdolling, set "STUNGUN.FreezeTime" to what you want, and "STUNGUN.ParalyzedTime" to 0
]]

-- !!!!! LOW LAG MODE !!!!!
-- If you run a server with large population you probably want to disable ragdolling as that can be quite laggy
-- Set STUNGUN.ParalyzedTime = 0 to disable ragdolling
-- Set STUNGUN.FreezeTime = to whatever you want instead

-- How many seconds the player becomes a ragdoll. Set to 0 to disable ragdolling completely (players will still be stunned and shaking with the FreezeTime).
STUNGUN.ParalyzedTime = 10

-- How many seconds the player is mute/gagged = Unable to speak/chat.
STUNGUN.MuteTime = 12

-- How many seconds after the player has been unragdolled that he will be frozen and shaking. Set to 0 to disable.
STUNGUN.FreezeTime = 3

-- Amount of seconds the player is immune to stuns after he has been unfrozen. -1 to disable.
STUNGUN.Immunity = 3

-- Ragdoll physics effect
-- Set to either 0, 1 or 2
-- 0: No effect, ragdoll lies still on the ground
-- 1: Original comical rolling around
-- 2: Shaking
STUNGUN.PhysEffect = 1

-- This affects how quickly the ragdoll will roll around, or shake. Set to 0.01 if you're having issues with too fast rolling.
STUNGUN.PhysEffectScale = 1

-- Should the player shake when it is in the frozen period?
STUNGUN.ShakeWhenFrozen = true

-- Can you un-taze people with stungun right click?
STUNGUN.CanUntaze = true

-- Should it display in thirdperson view for the tazed player? (if false, firstperson)
STUNGUN.Thirdperson = true

-- If above is true, should users be able to press crouch button (default ctrl) to switch between third and firstperson?
STUNGUN.AllowSwitchFromToThirdperson = true

-- Should people be able to pick a tazed player using physgun?
STUNGUN.AllowPhysgun = false

-- Should people be able to use toolgun on tazed players?
STUNGUN.AllowToolgun = false

-- Should tazed ragdolls take falldamage? (Warning: experimental, not recommended to have if players can pick them up using physgun.)
STUNGUN.Falldamage = true

-- How much damage the stungun also does, set to 0 to disable
STUNGUN.StunDamage = 0

-- Should the victim of a taze also drop the weapon he is carrying as he gets tazed?
STUNGUN.DropWeaponOnTaze = false

-- Should it display name and HP on tazed players?
STUNGUN.ShowPlayerInfo = true

-- Can the player be damaged by damage against the ragdoll when he's tazed?
STUNGUN.AllowDamage = true

-- Can the player suicide while he's paralyzed/ragdolled?
STUNGUN.ParalyzeAllowSuicide = false

-- Can the player suicide while he's mute?
STUNGUN.MuteAllowSuicide = false

-- The chance of a taze succeeding, in percent (100 = always succeeds, 0 = never succeeds)
STUNGUN.SuccessChance = 80

-- Can people of same team stun gun each other? Check further below (in the advanced section) for the check-function.
-- The check function is by default set to ignore police trying to taze police.
STUNGUN.AllowFriendlyFire = false

-- If the ragdoll version of the playermodel does not spawn correctly (incorrectly made model) then the ragdoll will be this model.
-- When done rolling around the player will get back his default model.
-- Set this to "nil" (without quotes) if you want to disable this default model and just make it not work.
STUNGUN.DefaultModel = Model("models/player/group01/male_01.mdl")

-- Thirdperson holdtype. Put "revolver" to make him carry the gun in 2 hands, put "pistol" to make him one-hand the gun.
SWEP.HoldType = "revolver"

-- Default charge for the weapon, when the guy picks the gun up, should it be filled already or wait to be filled?
SWEP.StartCharged = true

-- Should we have infinite ammo (true) or finite ammo (false)?
-- Finite ammo makes it spawn with 1 charge, unless you're running TTT in which you can specify how much ammo it should start with down below.
SWEP.InfiniteAmmo = false

-- Recharge time. How many seconds it takes to charge the gun back up.
SWEP.RechargeTime = 4

-- How long range the weapon has. Players beyond this range won't get hit.
-- To put in perspective, in DarkRP, the above-head player info has a default range of 400.
SWEP.Range = 400

-- What teams are immune to the stun gun? (if any).
local immuneteams = {
	TEAM_MAYOR,
	TEAM_CHIEF
}

--[[****************
DarkRP Specific stuff
Only care about these if you're running it on a DarkRP server.
*****************]]

-- Should the stun gun charges be buyable in the f4 store?
-- If yes, put in a number above 0 as price, if no, put -1 to disable.
STUNGUN.AddAmmoItem = 50

-- Should it be allowed to use the arrest baton on stunned people?
STUNGUN.AllowArrestOnRag = true

-- Should it be allowed to use the unarrest baton on stunned people?
STUNGUN.AllowUnArrestOnRag = true

--[[****************
TTT Specific stuff
Only care about these if you're running it on a TTT server.
*****************]]

-- Can stunned players be picked up by the magneto stick?
STUNGUN.CanPickup = false

-- Default ammo.
SWEP.Ammo = 3

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EQUIP1

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = false

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = { ROLE_DETECTIVE }

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = false

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

--[[****************
ADVANCED SECTION
Contact me if you need help with any function.
*****************]]
-- If you've found that specific models appear to break it, add them here and they will turn into the default model instead.
STUNGUN.BrokenModels = {
	["models/test/model.mdl"] = true
}

--[[
Hurt sounds
]]
local combinemodels = {["models/player/police.mdl"] = true, ["models/player/police_fem.mdl"] = true}
local females = {
	["models/player/alyx.mdl"] = true,["models/player/p2_chell.mdl"] = true,
	["models/player/mossman.mdl"] = true,["models/player/mossman_arctic.mdl"] = true}
function STUNGUN.PlayHurtSound( ply )
	local mdl = ply:GetModel()

	-- Combine
	if combinemodels[mdl] or string.find(mdl, "combine") then
		return "npc/combine_soldier/pain" .. math.random(1,3) .. ".wav"
	end

	-- Female
	if females[mdl] or string.find(mdl, "female") then
		return "vo/npc/female01/pain0" .. math.random(1,9) .. ".wav"
	end

	-- Male
	return "vo/npc/male01/pain0" .. math.random(1,9) .. ".wav"
end

--[[
Custom same-team function.
]]
function STUNGUN.SameTeam(ply1, ply2)
	if STUNGUN.IsDarkRP then
		if STUNGUN.IsDarkRP25 then
			if ply1:isCP() and ply2:isCP() then return true end
		else
			if ply1:IsCP() and ply2:IsCP() then return true end
		end
	end

	-- return (ply1:Team() == ply2:Team()) -- Probably dont want this in DarkRP, nor TTT, but maybe your custom TDM gamemode.
end

--[[
Custom Immunity function.
]]
function STUNGUN.IsPlayerImmune(ply)
	if type(immuneteams) == "table" and table.HasValue(immuneteams, ply:Team()) then return true end
	return false
end
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600