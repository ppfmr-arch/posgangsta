--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

--[[
Stun gun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
]]

include("shared.lua")

SWEP.PrintName = "Stun gun"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = (not SWEP.InfiniteAmmo)
SWEP.DrawCrosshair = false

language.Add("ammo_stungun_ammo", "Stun gun charge")
killicon.Add("stungun", "stungun/killicon", Color(255, 250, 0, 255))

if STUNGUN.IsTTT then
	-- TTT stuff
	-- Path to the icon material
	SWEP.Icon = "stungun/icon_stungun"

	LANG.AddToLanguage("english", "ammo_ammo_stungun", "Stun gun charge")

	local ammotext = ""
	if SWEP.InfiniteAmmo then
		ammotext = "\nIt has infinite charges."
	elseif SWEP.Ammo > 0 then
		ammotext = "\nIt has " .. SWEP.Ammo .. " charges."
	end

	-- Text shown in the equip menu
	SWEP.EquipMenuData = {
		type = "Weapon",
		desc = string.format("Stun gun used to paralyze enemies making them\nunable to speak and move for a few seconds.%s\n\nCreated by: Donkie",ammotext)
	}
end

SWEP.Screen = {}
SWEP.Screen.Pos = Vector(2.82, -5, 0)
SWEP.Screen.Ang = Angle(90, -20, -90)
SWEP.Screen.Size = 0.005
SWEP.Screen.w = 180
SWEP.Screen.h = 80
SWEP.Screen.y = -SWEP.Screen.h / 2
SWEP.Screen.x = -SWEP.Screen.w / 2

--[[
SWEP stuff
]]
function SWEP:OnDrop()
	self:Holster()
end

net.Receive("tazerondrop",function()
	local swep = net.ReadEntity()
	if not IsValid(swep) then return end
	swep:OnDrop()
end)

--[[
IN-HEAD VIEW
]]
hook.Add("PlayerBindPress", "Tazer", function(ply,bind,pressed)
	if bind == "+duck" and STUNGUN.Thirdperson and STUNGUN.AllowSwitchFromToThirdperson and IsValid(ply:GetNWEntity("tazerviewrag")) then
		if ply._stungunThirdPersonView == nil then
			ply._stungunThirdPersonView = false
		end

		ply._stungunThirdPersonView = not ply._stungunThirdPersonView
	end
end)

local dist = 200
local view = {drawviewer = false}
hook.Add("CalcView", "Tazer", function(ply, origin, angles, fov)
	local rag = ply:GetNWEntity("tazerviewrag")
	if not IsValid(rag) then return end

	local boneId = rag:LookupBone("ValveBiped.Bip01_Head1")
	if not boneId then return end

	local dothirdperson = false
	if STUNGUN.Thirdperson then
		if STUNGUN.AllowSwitchFromToThirdperson then
			dothirdperson = ply._stungunThirdPersonView
		else
			dothirdperson = true
		end
	end

	if dothirdperson then
		local ragpos = rag:GetBonePosition(boneId)

		local pos = ragpos - (ply:GetAimVector() * dist)
		local ang = (ragpos - pos):Angle()

		-- Do a traceline so he can't see through walls
		local trdata = {}
		trdata.start = ragpos
		trdata.endpos = pos
		trdata.filter = rag
		local trres = util.TraceLine(trdata)
		if trres.Hit then
			pos = trres.HitPos + (trres.HitWorld and trres.HitNormal * 3 or vector_origin)
		end

		view.origin = pos
		view.angles = ang
	else
		local pos,ang = rag:GetBonePosition(boneId)
		pos = pos + ang:Forward() * 7
		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), -90)
		pos = pos + ang:Forward() * 1

		view.origin = pos
		view.angles = ang
	end

	return view
end)

local minpos, minang = Vector(-16384, -16384, -16384), Angle(0,0,0)
hook.Add("CalcViewModelView", "Stungun", function(wep)
	if IsValid(wep.Owner) and IsValid(wep.Owner:GetNWEntity("tazerviewrag")) then
		return minpos, minang
	end
end)

--[[
Effects
]]
STUNGUN.RagdolledPlayers = {}

-- Used to cache DarkRP_EntityDisplay return value
local darkRPPlayersToDraw
local function updatePlayersToDraw()
	darkRPPlayersToDraw = {}
	for _, ply in pairs(player.GetAll()) do
		if not IsValid(STUNGUN.RagdolledPlayers[ply]) then
			darkRPPlayersToDraw[#darkRPPlayersToDraw + 1] = ply
		end
	end

	if #darkRPPlayersToDraw == #player.GetAll() then
		-- No difference, set to nil to show that we shouldn't return in the hook
		darkRPPlayersToDraw = nil
	end
end

local function hideCuffs(wep, hide)
	if hide then
		if wep.stungun_cuffsHidden then return end -- Already hidden

		wep.stungun_GetRopeLength = wep.GetRopeLength
		wep.GetRopeLength = function() return 0 end

		hook.Remove("PostDrawOpaqueRenderables", wep)
	else
		if not wep.stungun_cuffsHidden then return end -- Not hidden

		wep.GetRopeLength = wep.stungun_GetRopeLength

		wep.DrawWorldModel = weapons.Get("weapon_handcuffed").DrawWorldModel
	end

	wep.stungun_cuffsHidden = hide
end

local function nwProxy(ply, _, _, rag) -- This is also called when the NWVar gets set to nil so it works perfectly for this purpose
	STUNGUN.RagdolledPlayers[ply] = rag

	updatePlayersToDraw()

	-- Cuffs mod
	if IsValid(ply) and IsValid(ply:GetWeapon("weapon_handcuffed")) then
		local wep = ply:GetWeapon("weapon_handcuffed")
		hideCuffs(wep, IsValid(rag))
	end
end

hook.Add("OnEntityCreated", "StungunRagdoll", function(ent)
	if ent:IsPlayer() then
		ent:SetNWVarProxy("tazerviewrag", nwProxy)
	end

	if ent:IsRagdoll() then
		local ply = ent:GetDTEntity(1)

		if IsValid(ply) and ply:IsPlayer() then
			-- Only copy any decals if this ragdoll was recently created
			if ent:GetCreationTime() > CurTime() - 1 then
				ent:SnatchModelInstance(ply)
			end

			-- Copy the color for the PlayerColor matproxy
			local playerColor = ply:GetPlayerColor()
			ent.GetPlayerColor = function()
				return playerColor
			end
		end
	end
end)

hook.Add("EntityRemoved", "StungunRagdoll", function(ent)
	if ent:IsPlayer() then
		STUNGUN.RagdolledPlayers[ent] = nil
		updatePlayersToDraw()
	end

	if ent:IsRagdoll() then
		local ply = ent:GetDTEntity(1)

		if IsValid(ply) and ply:IsPlayer() then
			ply:SnatchModelInstance(ent)
		end
	end
end)

--[[
Flail arms
]]
local function setBoneAngles(datat)
	local t = CurTime() + datat.ply:UserID() * 10 -- Involve UserID so if multiple people are tazed at the same time they won't be synchronized
	if datat.boneSpine then datat.ply:ManipulateBoneAngles(datat.boneSpine, Angle(0, math.cos(t * 50) * 5 - 20, 0)) end
	if datat.boneNeck then datat.ply:ManipulateBoneAngles(datat.boneNeck, Angle(0, 20, 0)) end
	if datat.bonePelvis then datat.ply:ManipulateBonePosition(datat.bonePelvis, Vector(0, 0, math.cos(CurTime() * 100) * 0.3)) end
end

local angzero = Angle(0, 0, 0)
local veczero = Vector(0, 0, 0)
local function resetBoneAngles(datat)
	if datat.boneSpine then datat.ply:ManipulateBoneAngles(datat.boneSpine, angzero) end
	if datat.boneNeck then datat.ply:ManipulateBoneAngles(datat.boneNeck, angzero) end
	if datat.bonePelvis then datat.ply:ManipulateBonePosition(datat.bonePelvis, veczero) end
end

local playersFlailing = {}
local function playerBoneFlail(ply, endTime)
	if endTime > CurTime() then
		playersFlailing[ply] = {
			ply = ply,
			endTime = endTime,
			boneSpine = ply:LookupBone("ValveBiped.Bip01_Spine") or nil,
			boneNeck = ply:LookupBone("ValveBiped.Bip01_Neck1") or nil,
			bonePelvis = ply:LookupBone("ValveBiped.Bip01_Pelvis") or 0
		}
	else
		if playersFlailing[ply] and IsValid(playersFlailing[ply].ply) then
			resetBoneAngles(playersFlailing[ply])
		end

		playersFlailing[ply] = nil
	end
end

net.Receive("StungunFlail", function()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	local endTime = net.ReadDouble()

	playerBoneFlail(ply, endTime)
end)

hook.Add("Think", "StungunFlail", function()
	for ply, datat in pairs(playersFlailing) do
		if not IsValid(ply) then
			playersFlailing[ply] = nil
			return
		end

		if datat.endTime < CurTime() then
			resetBoneAngles(datat)
			playersFlailing[ply] = nil
			return
		end

		setBoneAngles(datat)
	end
end)

--[[
CROSSHAIR
]]
local crosshairColorHit = Color(0,150,0,255)
local crosshairColorMiss = Color(150,0,0,255)
local sw,sh = ScrW(), ScrH()
local w2,h2 = sw / 2, sh / 2
local length = 10
local rangeSqr = SWEP.Range * SWEP.Range
function SWEP:DrawHUD()
	if STUNGUN.IsTTT and GetConVar("ttt_disable_crosshair"):GetBool() then return end -- If a TTT player wants it disabled, so be it.

	local trres = self.Owner:GetEyeTrace()
	local hit = IsValid(trres.Entity) and trres.Entity:IsPlayer() and trres.HitPos:DistToSqr(LocalPlayer():GetShootPos()) <= rangeSqr

	surface.SetDrawColor(hit and crosshairColorHit or crosshairColorMiss)

	local gap = (hit and 0 or 10) + 5

	surface.DrawLine(w2 - length, h2, w2 - gap, h2)
	surface.DrawLine(w2 + length, h2, w2 + gap, h2)
	surface.DrawLine(w2, h2 - length, w2, h2 - gap)
	surface.DrawLine(w2, h2 + length, w2, h2 + gap)
end

--[[
TARGET ID
]]
-- Stops targetids from drawing in darkrp. TTT sadly has no hook like this.
hook.Add("HUDShouldDraw", "Tazer", function(hud)
	if hud == "DarkRP_EntityDisplay" and darkRPPlayersToDraw then
		return true, darkRPPlayersToDraw
	end
end)

local function IsOnScreen(pos)
	return pos.x > 0 and pos.x < sw and pos.y > 0 and pos.y < sh
end

local function GrabPlyInfo(ply)
	if STUNGUN.IsTTT then
		local text, color
		if ply:GetNWBool("disguised", false) then
			if LocalPlayer():IsTraitor() or LocalPlayer():IsSpec() then
				text = ply:Nick() .. LANG.GetUnsafeLanguageTable().target_disg
			else
				-- Do not show anything
				return
			end

			color = COLOR_RED
		else
			text = ply:Nick()
		end

		return text, (color or COLOR_WHITE), "TargetID"
	elseif STUNGUN.IsDarkRP then
		return ply:Nick(), (team.GetColor(ply:Team()) or color_white), "DarkRPHUD2"
	else
		return ply:Nick(), (team.GetColor(ply:Team()) or color_white), "TargetID"
	end
end

hook.Add("HUDPaint", "Tazer", function()
	-- Draws info about crouch able to switch between third and firstperson
	if STUNGUN.Thirdperson and STUNGUN.AllowSwitchFromToThirdperson and IsValid(LocalPlayer():GetNWEntity("tazerviewrag")) then
		local txt = string.format("Press %s to switch between third and firstperson view.", input.LookupBinding("+duck"))
		draw.SimpleText(txt, "TargetID", ScrW() / 2 + 1, 10 + 1, Color(0,0,0,255), 1)
		draw.SimpleText(txt, "TargetID", ScrW() / 2, 10, Color(200,200,200,255), 1)
	end

	-- Draws custom targetids on rags
	if not STUNGUN.ShowPlayerInfo then return end

	local targ = LocalPlayer():GetEyeTrace().Entity
	if IsValid(targ) and IsValid(targ:GetNWEntity("plyowner")) and LocalPlayer():GetPos():Distance(targ:GetPos()) < 400 then
		local pos = targ:GetPos():ToScreen()
		if IsOnScreen(pos) then
			local ply = targ:GetNWEntity("plyowner")
			local nick,nickclr,font = GrabPlyInfo(ply)
			if not nick then return end -- Someone doesn't want us to draw his info.

			draw.DrawText(nick, font, pos.x-1, pos.y - 51, Color(0,0,0), 1)
			draw.DrawText(nick, font, pos.x, pos.y - 50, nickclr, 1)

			local hp = (ply.newhp and ply.newhp or ply:Health())
			if STUNGUN.IsTTT then
				local txt,clr = util.HealthToString(hp) -- Grab TTT Data
				txt = LANG.GetUnsafeLanguageTable()[txt] -- Convert to whatever language
				draw.DrawText(txt, "TargetIDSmall2", pos.x-1, pos.y - 31, Color(0,0,0), 1)
				draw.DrawText(txt, "TargetIDSmall2", pos.x, pos.y - 30, clr, 1)
			elseif STUNGUN.IsDarkRP then
				local txt
				if STUNGUN.IsDarkRP25 then
					txt = DarkRP.getPhrase("health", hp)
				else
					txt = LANGUAGE.health .. hp
				end

				draw.DrawText(txt, "DarkRPHUD2", pos.x-1, pos.y - 31, Color(0,0,0), 1)
				draw.DrawText(txt, "DarkRPHUD2", pos.x, pos.y - 30, Color(255,255,255,200), 1)
			else
				local txt = hp .. "%"

				draw.DrawText(txt, "TargetID", pos.x-1, pos.y - 31, Color(0,0,0), 1)
				draw.DrawText(txt, "TargetID", pos.x, pos.y - 30, Color(255,255,255,200), 1)
			end
		end
	end
end)

-- For some reason, when they're ragdolled their hp isn't sent properly to the clients.
net.Receive("tazersendhealth", function()
	local ent = net.ReadEntity()
	local newhp = net.ReadInt(32)
	ent.newhp = newhp
end)

--[[
Handcuffs support!
]]
local lrender = {
	normal = {
		bone  = "ValveBiped.Bip01_Neck1",
		pos   = Vector(2,1.8,0),
		ang   = Angle(70,90,90),
		scale = Vector(0.06,0.06,0.05),
	},
	alt = { -- Eeveelotions models
		bone  = "Neck",
		pos   = Vector(1,0.5,-0.2),
		ang   = Angle(100,90,90),
		scale = Vector(0.082,0.082,0.082),
	},
}
local LeashHolder = "ValveBiped.Bip01_R_Hand"
local CuffMdl = "models/hunter/tubes/tube2x2x1.mdl"
local DefaultRope = "cable/cable2"
local function LEASHDrawWorldModel(self)
	if not IsValid(self.Owner) then return end

	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_LeftCuff ) then return end
		self.cmdl_LeftCuff:SetNoDraw( true )
		-- self.cmdl_LeftCuff:SetParent( vm )
	end

	local tbl = lrender.normal
	local lpos, lang = self:GetBonePos( tbl.bone, self.Owner )
	if not (lpos) then
		tbl = lrender.alt
		lpos, lang = self:GetBonePos( tbl.bone, self.Owner )
		if not (lpos) then return end
	end

	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward() * tbl.pos.x) + (lang:Right() * tbl.pos.y) + (lang:Up() * tbl.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() -- Prevents moving axes
	lang:RotateAroundAxis( u, tbl.ang.y )
	lang:RotateAroundAxis( r, tbl.ang.p )
	lang:RotateAroundAxis( f, tbl.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )

	local matrix = Matrix()
	matrix:Scale( tbl.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )

	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()

	if self:GetRopeMaterial() != self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end

	local ropestart = lpos
	local kidnapper = self:GetKidnapper()
	local ropeend = (kidnapper:IsPlayer() and kidnapper:GetPos() + Vector(0,0,37)) or kidnapper:GetPos()
	if kidnapper != LocalPlayer() or (hook.Run("ShouldDrawLocalPlayer", LocalPlayer())) then
		local lBone = kidnapper:LookupBone(LeashHolder)

		if lBone then
			local newPos = kidnapper:GetBonePosition( lBone )
			if newPos and (newPos.x != 0 and newPos.y != 0 and newPos.z != 0) then
				ropeend = newPos
			end
		end
	end

	render.SetMaterial( self.RopeMat )
	render.DrawBeam( ropestart, ropeend, 0.7, 0, 5, Color(255,255,255) )
	render.DrawBeam( ropeend, ropestart, -0.7, 0, 5, Color(255,255,255) )
end

local plymeta = FindMetaTable("Player")
hook.Add("PostDrawOpaqueRenderables", "STUNGUN_CUFFS", function()
	if not plymeta.IsHandcuffed then hook.Remove("PostDrawOpaqueRenderables", "STUNGUN_CUFFS") return end

	for ply, rag in pairs(STUNGUN.RagdolledPlayers) do
		if not IsValid(rag) then
			STUNGUN.RagdolledPlayers[ply] = nil
			continue
		end

		if not rag:GetNWString("cuffs_ropemat") or
			not rag:GetNWString("cuffs_cuffmat") or
			not isbool(rag:GetNWBool("cuffs_isleash")) or
			not IsValid(rag:GetNWEntity("cuffs_kidnapper")) then continue end

		if not rag.swep then
			local leashowner = rag:GetNWEntity("cuffs_kidnapper")
			local isleash = rag:GetNWBool("cuffs_isleash")

			rag.swep = {
				cuffmat = rag:GetNWString("cuffs_cuffmat"),
				ropemat = rag:GetNWString("cuffs_ropemat"),
				GetBonePos = weapons.Get("weapon_handcuffed").GetBonePos,
				GetCuffMaterial = function(self) return self.cuffmat end,
				GetRopeMaterial = function(self) return self.ropemat end,
				GetIsLeash = function() return isleash end,
				GetKidnapper = function() return leashowner end,
				Owner = rag
			}

			if isleash then
				rag.swep.DrawWorldModel = LEASHDrawWorldModel
			else
				rag.swep.DrawWorldModel = weapons.Get("weapon_handcuffed").DrawWorldModel
			end
		end

		rag.swep:DrawWorldModel()
	end
end)

--[[
Deploy
]]
function SWEP:CalcViewModelView(vm, oldEyePos, oldEyeAngles, eyePos, eyeAngles)
	if self.IsDeployed then return end

	local frac = ((self.AnimDeploy or 0) - CurTime()) / self.DeployTime
	frac = math.Clamp(frac, 0, 1)
	frac = frac * frac * frac -- tweening

	return eyePos, eyeAngles + Angle(20 * frac, 0, 0)
end

--[[
Screen
]]
surface.CreateFont( "StungunScreenFont", {
	font = "Arial",
	size = 34,
	weight = 500,
	antialias = true,
} )

local colRed = HSVToColor(0, 0.8, 0.8)
local colGreen = HSVToColor(90, 0.8, 0.8)
function SWEP:DrawScreen(x, y, w, h)
	local frac = self:GetCharge()
	local text, textcol
	local charging = false
	if not self.ChargeInserted then
		text = "Insert charge"
		textcol = colRed
	elseif self:Clip1() == 0 then
		text = "Charge empty"
		textcol = colRed
	elseif frac < 1 then
		charging = true
		text = "Charging" .. string.rep(".", (CurTime() * 6) % 3)
		textcol = HSVToColor(45 + 45 * frac, 0.8, 0.8)
	else
		text = "Ready"
		textcol = colGreen
	end

	if text then
		draw.SimpleText(text, "StungunScreenFont", x + 4, y + 2, textcol)
	end

	if charging then
		local barTall = 20
		surface.SetDrawColor(textcol)
		surface.DrawRect(x, y + h - barTall - 10, w * frac, barTall)
	end
end

function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if not IsValid(vm) then return end

	if not self.gunBone then
		self.gunBone = vm:LookupBone("x26_groot")
	end

	if not self.gunBone then return end

	local pos, ang = Vector(0,0,0), Angle(0,0,0)
	local m = vm:GetBoneMatrix(self.gunBone)
	if m then
		pos, ang = m:GetTranslation(), m:GetAngles()
	end

	local posOff = self.Screen.Pos
	local angOff = self.Screen.Ang

	local drawpos = pos + ang:Forward() * posOff.x + ang:Right() * posOff.y + ang:Up() * posOff.z
	ang:RotateAroundAxis(ang:Up(), angOff.y)
	ang:RotateAroundAxis(ang:Right(), angOff.p)
	ang:RotateAroundAxis(ang:Forward(), angOff.r)

	cam.Start3D2D(drawpos, ang, self.Screen.Size)
		self:DrawScreen(self.Screen.x, self.Screen.y, self.Screen.w, self.Screen.h)
	cam.End3D2D()
end

--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600