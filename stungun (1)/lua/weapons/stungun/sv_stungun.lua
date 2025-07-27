--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

--[[
Makes a hull trace the size of a player.
]]
local hulltrdata = {}
function STUNGUN.PlayerHullTrace(pos, ply, filter)
	hulltrdata.start = pos
	hulltrdata.endpos = pos
	hulltrdata.filter = filter

	return util.TraceEntity( hulltrdata, ply )
end

--[[
Attemps to place the player at this position or as close as possible.
]]
-- Directions to check
local directions = {
	Vector(0,0,0), Vector(0,0,1), -- Center and up
	Vector(1,0,0), Vector(-1,0,0), Vector(0,1,0), Vector(0,-1,0) -- All cardinals
	}
for deg = 45, 315, 90 do -- Diagonals
	local r = math.rad(deg)
	table.insert(directions, Vector(math.Round(math.cos(r)), math.Round(math.sin(r)), 0))
end

local magn = 15 -- How much increment for each iteration
local iterations = 2 -- How many iterations
function STUNGUN.PlayerSetPosNoBlock( ply, pos, filter )
	local tr

	local dirvec
	local m = magn
	local i = 1
	local its = 1
	repeat
		dirvec = directions[i] * m
		i = i + 1
		if i > #directions then
			its = its + 1
			i = 1
			m = m + magn
			if its > iterations then
				ply:SetPos(pos) -- We've done as many checks as we wanted, lets just force him to get stuck then.
				return false
			end
		end

		tr = STUNGUN.PlayerHullTrace(dirvec + pos, ply, filter)
	until tr.Hit == false

	ply:SetPos(pos + dirvec)
	return true
end

--[[
Sets the player invisible/visible
]]
local hideWorldModels = {}
function STUNGUN.PlayerInvis(ply, bool)
	ply:SetNoDraw(bool)
	ply:DrawShadow(not bool)
	ply:SetCollisionGroup(bool and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_PLAYER)
	ply:SetNotSolid(bool)
	ply:DrawWorldModel(not bool)
	hideWorldModels[ply] = bool or nil

	ply:Freeze(bool)
end

hook.Add("PlayerSwitchWeapon", "StungunStuff", function(ply, old, new)
	timer.Simple(0, function()
		if IsValid(ply) and hideWorldModels[ply] then
			ply:DrawWorldModel(false)
		end
	end)

	if ply:GetNWBool("tazefrozen", false) then
		return false
	end
end)

--[[
Tazer noise
]]
local tazersnd = Sound("stungun/tazer.wav")
local function removeTazerNoise(ent)
	if ent.tazesnd then
		ent.tazesnd:Stop()
		ent.tazesnd = nil
	end
end

local function createTazerNoise(ent)
	removeTazerNoise(ent) -- Remove any existing

	ent.tazesnd = CreateSound(ent, tazersnd)
	ent.tazesnd:PlayEx(1, 80)
end

STUNGUN.RagdolledPlayers = {}

--[[
Ragdolling
]]
function STUNGUN.Ragdoll(ply, pushdir)
	local plyphys = ply:GetPhysicsObject()
	local plyvel = Vector(0,0,0)
	if plyphys:IsValid() then
		plyvel = plyphys:GetVelocity()
	end

	ply.tazedpos = ply:GetPos() -- Store pos incase the ragdoll is missing when we're to unrag him.

	local mdl = ply:GetModel()
	if STUNGUN.BrokenModels[mdl] then
		mdl = STUNGUN.DefaultModel
	end

	local rag = ents.Create("prop_ragdoll")
		rag:SetModel(mdl)
		rag:SetPos(ply:GetPos())
		rag:SetAngles(Angle(0,ply:GetAngles().y,0))
		rag:SetColor(ply:GetColor())
		rag:SetMaterial(ply:GetMaterial())
		rag:SetSkin(ply:GetSkin())
		rag:Spawn()
		rag:Activate()

	for bdgrp = 0, ply:GetNumBodyGroups() - 1 do
		rag:SetBodygroup(bdgrp, ply:GetBodygroup(bdgrp))
	end

	if not IsValid(rag:GetPhysicsObject()) then
		SafeRemoveEntity(rag)

		if STUNGUN.DefaultModel then
			rag = ents.Create("prop_ragdoll")
				rag:SetModel(STUNGUN.DefaultModel)
				rag:SetPos(ply:GetPos())
				rag:SetAngles(Angle(0,ply:GetAngles().y,0))
				rag:SetColor(ply:GetColor())
				rag:SetMaterial(ply:GetMaterial())
				rag:Spawn()
				rag:Activate()
		else
			MsgN("A tazed player didn't get a valid ragdoll. Model (" .. ply:GetModel() .. ")!")
			return false
		end
	end

	createTazerNoise(rag)

	-- Lower inertia makes the ragdoll have trouble rolling. Citizens have 1,1,1 as default, while combines have 0.2,0.2,0.2.
	rag:GetPhysicsObject():SetInertia(Vector(1,1,1))

	-- Set mass of all limbs, forces and shit are weird if mass is not same.
	for i = 1, rag:GetPhysicsObjectCount() do
		if IsValid(rag:GetPhysicsObject(i-1)) then
			rag:GetPhysicsObject(i-1):SetMass(12.7)
		end
	end

	-- Push him back abit
	plyvel = plyvel + pushdir * 30

	-- Makes the ragdolls bones match up the player's bones. Taken from TTT
	local num = rag:GetPhysicsObjectCount() - 1
	for i = 0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
			local bp, ba = ply:GetBonePosition(rag:TranslatePhysBoneToBone(i))
			if bp and ba then
				bone:SetPos(bp)
				bone:SetAngles(ba)
			end

			bone:SetVelocity(plyvel)
		end
	end

	-- Prevents any kind of pickup if user don't want him to
	rag.CanPickup = STUNGUN.CanPickup

	-- Handcuff support
	local cuffs = ply:GetWeapon("weapon_handcuffed")
	if IsValid(cuffs) then
		if cuffs:GetIsLeash() then
			rag.isleashed = true
			rag.leashowner = cuffs:GetKidnapper()
			rag.ropelength = cuffs:GetRopeLength()
		else
			rag.iscuffed = true
		end

		rag:SetNWBool("cuffs_isleash", rag.isleashed)
		rag:SetNWEntity("cuffs_kidnapper", cuffs:GetKidnapper())
		rag:SetNWString("cuffs_ropemat", cuffs:GetRopeMaterial())
		rag:SetNWString("cuffs_cuffmat", cuffs:GetCuffMaterial())
	end

	-- Make him follow the ragdoll, if the player gets away from the ragdoll he won't get stuff rendered properly.
	ply:SetParent(rag)

	-- Make the player invisible.
	STUNGUN.PlayerInvis(ply, true)

	STUNGUN.RagdolledPlayers[ply] = rag
	ply.tazeragdoll = rag
	rag.tazeplayer = ply
	rag:SetDTEntity(1, ply) -- Used to gain instant access to player on client

	if STUNGUN.IsDarkRP then
		STUNGUN.InitDarkRPFunctions(rag)
	end

	ply:SetNWEntity("tazerviewrag", rag)
	rag:SetNWEntity("plyowner", ply)

	ply.lasthp = ply:Health()
	net.Start("tazersendhealth")
		net.WriteEntity(ply)
		net.WriteInt(ply:Health(),32)
	net.Broadcast()
	return true
end

function STUNGUN.UnRagdoll(ply)
	local pos = ply:GetPos() -- Fallback position
	if STUNGUN.IsRagdolled(ply) then -- Sometimes the ragdoll is missing when we want to unrag, not good!
		if ply.tazeragdoll.hasremoved then return end -- It has already been removed.

		pos = ply.tazeragdoll:GetPos() + Vector(0, 0, 10)

		removeTazerNoise(ply.tazeragdoll)

		ply.tazeragdoll.hasremoved = true
	else
		pos = ply.tazedpos -- Put him at the place he got tazed, works great.
	end
	ply:SetParent()

	STUNGUN.RagdolledPlayers[ply] = nil
	STUNGUN.PlayerSetPosNoBlock(ply, pos, {ply, ply.tazeragdoll})

	timer.Simple(0,function()
		if not IsValid(ply) then return end
		SafeRemoveEntity(ply.tazeragdoll)
		STUNGUN.PlayerInvis(ply, false)
	end)
end

function STUNGUN.IsRagdolled(ply)
	return IsValid(ply.tazeragdoll)
end

function STUNGUN.GetRagdoll(ply)
	return ply.tazeragdoll
end

--[[
Flailing
]]
util.AddNetworkString("StungunFlail")
local playersFlailing = {}
function STUNGUN.StartFlail(ply, duration)
	local stop = CurTime() + duration

	playersFlailing[ply] = stop
	net.Start("StungunFlail")
		net.WriteEntity(ply)
		net.WriteDouble(stop)
	net.Broadcast()
end

function STUNGUN.StopFlail(ply)
	if not STUNGUN.IsFlailing(ply) then return end

	net.Start("StungunFlail")
		net.WriteEntity(ply)
		net.WriteDouble(0)
	net.Broadcast()
end

function STUNGUN.IsFlailing(ply)
	return playersFlailing[ply] and playersFlailing[ply] >= CurTime()
end

--[[
Electrolution
STUNGUN.Electrocute is what is called by the stungun when it hits a player.
It ragdolls the player, adds the sound and starts gagging/muting timers.
]]

function STUNGUN.Electrocute(ply, pushdir)
	-- Select a nice weapon
	if STUNGUN.IsDarkRP then
		ply:SelectWeapon("keys")
	elseif STUNGUN.IsTTT then
		ply:SelectWeapon("weapon_ttt_unarmed")
	end

	-- Ragdoll
	if STUNGUN.ParalyzedTime > 0 then
		STUNGUN.Ragdoll(ply, pushdir)
	else
		createTazerNoise(ply)
	end

	-- Freeze
	ply:SetNWBool("tazefrozen", true)

	-- Gag
	ply.tazeismuted = true

	local id = ply:UserID()
	timer.Create("Unelectrolute" .. id, STUNGUN.ParalyzedTime, 1, function()
		if IsValid(ply) then STUNGUN.UnElectrocute(ply, true) end
	end)

	timer.Create("tazeUngag" .. id, STUNGUN.MuteTime, 1, function()
		if IsValid(ply) then STUNGUN.UnMute(ply) end
	end)

	ply:EmitSound(STUNGUN.PlayHurtSound(ply), 100, 100)
	timer.Create("HurtingTimer" .. id, 2, 0, function()
		if not IsValid(ply) or not ply:GetNWBool("tazefrozen", false) then
			timer.Remove("HurtingTimer" .. id)
			return
		end

		ply:EmitSound(STUNGUN.PlayHurtSound(ply), 100, 100)
	end)

	hook.Run("PlayerHasBeenTazed", ply, ply.tazeragdoll)
end
STUNGUN.Electrolute = STUNGUN.Electrocute

function STUNGUN.UnMute(ply)
	timer.Remove("tazeUngag" .. ply:UserID())
	ply.tazeismuted = false
end

-- Un-freezes the player, finishing the final step in the taze sequence
function STUNGUN.UnFreeze(ply)
	ply:SetNWBool("tazefrozen", false)

	removeTazerNoise(ply)

	STUNGUN.StopFlail(ply)

	timer.Remove("HurtingTimer" .. ply:UserID())

	hook.Run("PlayerTazeUnFrozen", ply)

	if STUNGUN.Immunity > 0 then
		ply.tazeimmune = true
		timer.Simple(STUNGUN.Immunity, function()
			if IsValid(ply) then
				ply.tazeimmune = false
			end
		end)
	end
end

-- Un-ragdolls the player and begins the freezing phase if allowFreeze is true
function STUNGUN.UnElectrocute(ply, allowFreeze)
	if STUNGUN.ParalyzedTime > 0 then
		STUNGUN.UnRagdoll(ply)
	end

	local id = ply:UserID()
	timer.Remove("Unelectrolute" .. id)

	hook.Run("PlayerUnTazed", ply)

	if allowFreeze and (STUNGUN.FreezeTime or 0) > 0 then
		if STUNGUN.ShakeWhenFrozen != false then -- Backwards compatibility
			STUNGUN.StartFlail(ply, STUNGUN.FreezeTime)
		end

		-- We want to continue the tazer noise after the guy gets unragdolled
		createTazerNoise(ply)

		timer.Create("StungunPlayerFreeze" .. id, STUNGUN.FreezeTime, 1, function()
			if not IsValid(ply) then return end

			STUNGUN.UnFreeze(ply)
		end)
	else
		STUNGUN.UnFreeze(ply)
	end
end
STUNGUN.Unelectrolute = STUNGUN.UnElectrocute
STUNGUN.UnElectrolute = STUNGUN.UnElectrocute

hook.Add("PlayerSay", "Tazer", function(ply, str)
	if ply.tazeismuted then return "" end
end)

local function thinkCuffs(rag)
	local lhandbonenum = rag:LookupBone("ValveBiped.Bip01_L_Hand")
	local rhandbonenum = rag:LookupBone("ValveBiped.Bip01_R_Hand")
	if lhandbonenum and rhandbonenum then
		local lhandnum = rag:TranslateBoneToPhysBone(lhandbonenum)
		local rhandnum = rag:TranslateBoneToPhysBone(rhandbonenum)

		if lhandnum and rhandnum then
			local lhand = rag:GetPhysicsObjectNum(lhandnum)
			local rhand = rag:GetPhysicsObjectNum(rhandnum)

			if lhand and rhand then
				local vel = (rhand:GetPos() - lhand:GetPos()) * 130 * FrameTime()
				lhand:AddVelocity(vel)
				rhand:AddVelocity(-vel)
			end
		end
	end
end

local function thinkLeash(rag, holder, ropeLength)
	local headPos = rag:GetPos()
	local phys = rag:GetPhysicsObjectNum(0)
	local bone = rag:LookupBone("ValveBiped.Bip01_Neck1")
	if bone then
		local matrix = rag:GetBoneMatrix(bone)
		if matrix then
			headPos = matrix:GetTranslation()
		end

		if rag:TranslateBoneToPhysBone(bone) then
			phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(bone))
		end
	end

	local targetPoint = (holder:IsPlayer() and holder:GetShootPos()) or holder:GetPos()
	local moveDir = (targetPoint - headPos):GetNormal()

	local distFromTarget = headPos:Distance(targetPoint)
	if distFromTarget <= ropeLength + 5 then return end

	local targetPos = targetPoint - (moveDir * ropeLength)

	local vel = (targetPos - headPos) * 66 * FrameTime()
	phys:AddVelocity(vel)
end

local thinkPhysEffect
do
	local mode = 0
	if STUNGUN.PhysEffect then
		mode = STUNGUN.PhysEffect
	elseif STUNGUN.ShouldRoll != nil then -- Backwards compatibility
		mode = STUNGUN.ShouldRoll and 1 or 0
	end

	if mode == 1 or mode == 2 then
		thinkPhysEffect = function(rag)
			local phys = rag:GetPhysicsObjectNum(0)
			if not IsValid(phys) then return end

			if mode == 1 then
				phys:AddAngleVelocity(Vector(0, math.sin(CurTime()) * 16650 * FrameTime() * (STUNGUN.PhysEffectScale or 1), 0))
			elseif mode == 2 then
				local vel = Vector(0, 0, math.sin(CurTime() * 100)) * 5000 * FrameTime() * (STUNGUN.PhysEffectScale or 1)
				for i = 1, rag:GetPhysicsObjectCount() do
					if IsValid(rag:GetPhysicsObject(i-1)) then
						rag:GetPhysicsObjectNum(i-1):AddVelocity(vel)
					end
				end
			end
		end
	else
		thinkPhysEffect = function() end
	end
end

-- We need these functions to prevent infinite loops in the EntityTakeDamage hook
-- Use takeRagdollDamage if you want to directly damage the player whilst he's being ragdolled
local playersTakingRagdollDamage = {}
local function takeRagdollDamage(ply, dmginfo)
	playersTakingRagdollDamage[ply] = true
	ply:TakeDamageInfo(dmginfo)
	playersTakingRagdollDamage[ply] = nil
end

local function isTakingRagdollDamage(ply)
	return playersTakingRagdollDamage[ply] or false
end

local thinkFallDamage
if STUNGUN.Falldamage then
	local function DoFallDmg(ply, vel, veldir, umph)
		local dmg = math.floor(hook.Run("GetFallDamage", ply, vel))
		if dmg != 0 then
			local dmginfo = DamageInfo()
				dmginfo:SetDamageType(DMG_FALL)
				dmginfo:SetDamage(dmg)
				dmginfo:SetDamageForce(vel * veldir)
				dmginfo:SetDamagePosition(ply.tazeragdoll:GetPos())
				dmginfo:SetAttacker(game.GetWorld())
				dmginfo:SetInflictor(game.GetWorld())

			takeRagdollDamage(ply, dmginfo)
		end
	end

	thinkFallDamage = function(rag)
		local phys = rag:GetPhysicsObject()
		local vel = phys:GetVelocity():Length()

		rag.lastfallvel = rag.lastfallvel or vel

		if vel >= rag.lastfallvel then
			rag.lastfallvel = vel
		else
			local deltavel = (rag.lastfallvel - vel)
			local umph = deltavel * FrameTime() -- Retardation
			umph = umph * umph -- More realistic when squared
			if umph > 50 then
				DoFallDmg(rag.tazeplayer, deltavel, phys:GetVelocity():GetNormal(), umph)
				rag.lastfallvel = 0
			end
		end
	end
else
	thinkFallDamage = function() end
end

util.AddNetworkString("tazersendhealth")
hook.Add("Think", "Tazer", function()
	for ply, rag in pairs(STUNGUN.RagdolledPlayers) do
		if not IsValid(ply) or not IsValid(rag) then
			STUNGUN.RagdolledPlayers[ply] = nil
			continue
		end

		-- Send new health. The normal health sending is somehow broken when ragdolled.
		if ply:Health() != ply.lasthp then
			net.Start("tazersendhealth")
				net.WriteEntity(ply)
				net.WriteInt(ply:Health(),32)
			net.Broadcast()
			ply.lasthp = ply:Health()
		end

		-- Apply the comical physical effect
		thinkPhysEffect(rag)

		-- Apply fall damage
		thinkFallDamage(rag)

		-- Pulls the hands together if he's cuffed
		if rag.iscuffed then
			thinkCuffs(rag)
		-- Pull ragdoll towards kidnapper if leashed
		elseif IsValid(rag.leashowner) then
			thinkLeash(rag, rag.leashowner, rag.ropelength)
		end
	end
end)

hook.Add("EntityTakeDamage", "Tazer", function(ent, dmginfo)
	if ent:IsPlayer() and STUNGUN.IsRagdolled(ent) and not isTakingRagdollDamage(ent) then
		-- If a ragdolled player takes damage directly, instead of the ragdoll taking the damage, we should zero it.
		dmginfo:SetDamage(0)
		return
	end

	local ply = ent.tazeplayer
	local atkr = dmginfo:GetAttacker()

	if not STUNGUN.AllowDamage or
		not IsValid(ply) or
		not IsValid(atkr) or
		atkr == game.GetWorld() then -- Worldspawn appears to be very eager to damage ragdolls. Don't!
		return
	end

	if STUNGUN.IsDarkRP and
		atkr:IsPlayer() and
		IsValid(atkr:GetActiveWeapon()) and
		atkr:GetActiveWeapon():GetClass() == "stunstick" then
		return
	end

	takeRagdollDamage(ply, dmginfo)

	hook.Run("PlayerDamagedWhileTazed", ply, dmginfo)
end)

function STUNGUN.CleanupParalyze(ply)
	removeTazerNoise(ply)

	STUNGUN.StopFlail(ply)

	if IsValid(ply.tazeragdoll) then
		removeTazerNoise(ply.tazeragdoll)

		timer.Simple(0,function()
			SafeRemoveEntity(ply.tazeragdoll)
		end)

		timer.Remove("HurtingTimer" .. ply:UserID())
		timer.Remove("Unelectrolute" .. ply:UserID())
		timer.Remove("tazeUngag" .. ply:UserID())
		timer.Remove("StungunPlayerFreeze" .. ply:UserID())

		ply:SetNWBool("tazefrozen", false)

		-- While he'll respawn and get this reset, his deadbody won't be visible so we need to reset it here.
		STUNGUN.PlayerInvis(ply, false)

		-- If he's respawning the immediate un-invisible won't have any effect. We need some delay.
		timer.Simple(.5,function()
			STUNGUN.PlayerInvis(ply, false)
		end)
	end

	ply.tazeismuted = false
end

function STUNGUN.DropActiveWeapon(ply)
	local wep = ply:GetActiveWeapon()
	if not IsValid(ply:GetActiveWeapon()) or wep:GetModel() == "" then return end

	local defdrop = hook.Run("StungunTazedDropWeapon", ply)
	if defdrop == true then return end -- Someone else handled this

	if STUNGUN.IsDarkRP then
	    local canDrop = hook.Call("canDropWeapon", GAMEMODE, ply, wep)
	    if not canDrop then return end

		ply:dropDRPWeapon(wep)

		ply:SelectWeapon("keys")
	elseif STUNGUN.IsTTT then
		WEPS.DropNotifiedWeapon(ply, wep)
	else
		ply:DropWeapon(wep)
		wep:PhysWake()
	end
end

-- If someone removes the ragdoll, untaze the player.
hook.Add("EntityRemoved", "Tazer", function(ent)
	if IsValid(ent.tazeplayer) and not ent.hasremoved then
		STUNGUN.UnRagdoll(ent.tazeplayer)
	end
end)

-- Some code directly respawns the player using :Spawn() without even killing him. We need to remove shit then.
hook.Add("PlayerSpawn", "Tazer", function(ply)
	STUNGUN.CleanupParalyze(ply)
end)
-- If he dies, clean up.
hook.Add("DoPlayerDeath", "Tazer", function(ply, inf, atk)
	STUNGUN.CleanupParalyze(ply)
end)

hook.Add("PlayerCanSeePlayersChat", "Tazer", function(text, teamOnly, listener, talker)
	if IsValid(talker) and (not STUNGUN.IsTTT or GetRoundState() == ROUND_ACTIVE) and talker.tazeismuted then
		return false
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "Tazer", function(listener, talker)
	if (not STUNGUN.IsTTT or GetRoundState() == ROUND_ACTIVE) and talker.tazeismuted then
		return false,false
	end
end)

hook.Add("CanPlayerSuicide", "Tazer", function(ply)
	if not STUNGUN.ParalyzeAllowSuicide and IsValid(ply.tazeragdoll) then return false end
	if not STUNGUN.MuteAllowSuicide and ply.tazeismuted then return false end
end)

hook.Add("PlayerCanPickupWeapon", "Tazer", function(ply, wep)
	if IsValid(ply.tazeragdoll) then return false end
end)

hook.Add("CuffsCanHandcuff", "Tazer", function(ply, target)
	if IsValid(target.tazeragdoll) then return false end
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "Tazer", function(data)
	local ply = Player(data.userid)
	if not IsValid(ply) then return end

	-- Taken from CleanupParalyze, slightly simplified though
	removeTazerNoise(ply)
	hideWorldModels[ply] = nil

	if IsValid(ply.tazeragdoll) then
		removeTazerNoise(ply.tazeragdoll)

		SafeRemoveEntity(ply.tazeragdoll)

		timer.Remove("HurtingTimer" .. ply:UserID())
		timer.Remove("Unelectrolute" .. ply:UserID())
		timer.Remove("tazeUngag" .. ply:UserID())
	end
end)

--[[
DarkRP specifics
]]
-- I'm not sure of the differences between these but one of them lets me put a nice message, while the other takes account in all cases. So I use both.
hook.Add("canChangeJob", "Tazer", function(ply, job)
	if IsValid(ply.tazeragdoll) then
		return false, "You can't change job while paralyzed!"
	end
end)
hook.Add("playerCanChangeTeam", "Tazer", function(ply)
	if IsValid(ply.tazeragdoll) then
		return false
	end
end)

--[[
Arrestfunc
]]
local arrestfunc = function(rag, cop)
	local ply = rag.tazeplayer
	if not IsValid(ply) then return end

	-- The onArrestStickUsed is called before all validity checks are done, so I need to do them myself.
	if STUNGUN.IsDarkRP25 then
		-- DarkRP 2.5
		local canArrest, message = hook.Call("canArrest", DarkRP.hooks, cop, ply)
		if not canArrest then
			if message then DarkRP.notify(cop, 1, 5, message) end
			return
		end

		-- Unragging
		STUNGUN.UnMute( ply )
		STUNGUN.UnElectrocute( ply )
		local id = ply:UserID()
		timer.Remove("Unelectrolute" .. id)
		timer.Remove("tazeUngag" .. id)

		-- Arresting
		timer.Simple(0.1, function()
			if not IsValid(ply) or not IsValid(cop) then return end

			ply:arrest(nil, cop)
		end)

		DarkRP.notify(ply, 0, 20, DarkRP.getPhrase("youre_arrested_by", cop:Nick()))

		if cop.SteamName then
			DarkRP.log(cop:Nick() .. " (" .. cop:SteamID() .. ") arrested " .. ply:Nick() .. " (victim was stungun-ragdolled)", Color(0, 255, 255))
		end
	else
		if cop:EyePos():Distance(rag:GetPos()) > 90 then return end

		-- Backwards compatibility (2.4.3)
		if ply:IsCP() and not GAMEMODE.Config.cpcanarrestcp then
			GAMEMODE:Notify(cop, 1, 5, "You can not arrest other CPs!")
			return
		end

		if GAMEMODE.Config.needwantedforarrest and not ply.DarkRPVars.wanted then
			GAMEMODE:Notify(cop, 1, 5, "The player must be wanted in order to be able to arrest them.")
			return
		end

		if FAdmin and ply:FAdmin_GetGlobal("fadmin_jailed") then
			GAMEMODE:Notify(cop, 1, 5, "You cannot arrest a player who has been jailed by an admin.")
			return
		end

		local jpc = DB.CountJailPos()
		if not jpc or jpc == 0 then
			GAMEMODE:Notify(cop, 1, 4, "You cannot arrest people since there are no jail positions set!")
			return
		end

		-- Unragging
		STUNGUN.UnMute( ply )
		STUNGUN.UnElectrocute( ply )
		local id = ply:UserID()
		timer.Remove("Unelectrolute" .. id)
		timer.Remove("tazeUngag" .. id)

		-- Arresting
		timer.Simple(0.1, function()
			ply:Arrest()
		end)

		GAMEMODE:Notify(ply, 0, 20, "You've been arrested by " .. cop:Nick())

		if cop.SteamName then
			DB.Log(cop:SteamName() .. " (" .. cop:SteamID() .. ") arrested " .. ply:Nick() .. " (victim was stungun-ragdolled)", nil, Color(0, 255, 255))
		end
	end
end

--[[
Unarrestfunc
]]
local unarrestfunc = function(rag, cop)
	local ply = rag.tazeplayer
	if not IsValid(ply) then return end

	-- The onUnArrestStickUsed is called before all validity checks are done, so I need to do them myself.
	if STUNGUN.IsDarkRP25 then
		-- DarkRP 2.5

		if not ply:getDarkRPVar("Arrested") then return end

		local hookCanUnarrest = {canUnarrest = fp{fn.Id, true}}
		local canUnarrest, message = hook.Call("canUnarrest", hookCanUnarrest, cop, ply)
		if not canUnarrest then
			if message then DarkRP.notify(cop, 1, 5, message) end
			return
		end

		STUNGUN.UnMute( ply )
		STUNGUN.UnElectrocute( ply )
		local id = ply:UserID()
		timer.Remove("Unelectrolute" .. id)
		timer.Remove("tazeUngag" .. id)

		timer.Simple(0.1,function()
			ply:unArrest(cop)
			DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("youre_unarrested_by", cop:Nick()))

			if cop.SteamName then
				DarkRP.log(cop:Nick() .. " (" .. cop:SteamID() .. ") unarrested " .. ply:Nick() .. " (victim was stungun-ragdolled)", Color(0, 255, 255))
			end
		end)
	else
		-- Backwards compatibility (2.4.3)
		if cop:EyePos():Distance(rag:GetPos()) > 115 then return end

		if not ply.DarkRPVars.Arrested then return end

		STUNGUN.UnMute( ply )
		STUNGUN.UnElectrocute( ply )
		local id = ply:UserID()
		timer.Remove("Unelectrolute" .. id)
		timer.Remove("tazeUngag" .. id)

		timer.Simple(0.1,function()
			ply:Unarrest()
			GAMEMODE:Notify(ply, 0, 4, "You were unarrested by " .. cop:Nick())

			if cop.SteamName then
				DB.Log(cop:SteamName() .. " (" .. cop:SteamID() .. ") unarrested " .. ply:Nick() .. " (victim was stungun-ragdolled)", nil, Color(0, 255, 255))
			end
		end)
	end
end

--[[
Call on a ragdoll to set it up with the arrest and unarrest functions required
]]
function STUNGUN.InitDarkRPFunctions(rag)
	if STUNGUN.AllowArrestOnRag then
		rag.onArrestStickUsed = arrestfunc
	end
	if STUNGUN.AllowUnArrestOnRag then
		rag.onUnArrestStickUsed = unarrestfunc
	end
end
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600