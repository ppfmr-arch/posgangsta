local gradient = Material("gui/gradient_down")
local logo = Material( "skeypad/keypad.png", "noclamp smooth" )
local fingerprintMat = Material( "skeypad/fingerprint.png", "noclamp smooth" )
local keycodeMat = Material( "skeypad/passcode.png", "noclamp smooth" )

TOOL.Category		= "Construction"
TOOL.Name			= "sKepads"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "inverse" ] = 0
TOOL.ClientConVar[ "authcanedit" ] = 0
TOOL.ClientConVar[ "pw" ] = 1234
TOOL.ClientConVar[ "timer" ] = 5
TOOL.ClientConVar[ "mode" ] = 0

local hoverHalos = {}

local green, white = Color(0,200,0), Color(255,255,255)
function TOOL:LeftClick( trace, bypass )
	if self.lastPrimary and !bypass and self.lastPrimary > CurTime() then return false end

	if !bypass then self.lastPrimary = CurTime() + .3 end

	local pw = isnumber(self:GetClientNumber("pw")) and (#tostring(self:GetClientNumber("pw")) > 4 ) and string.sub(self:GetClientNumber("pw"), 1, 4) or self:GetClientNumber("pw")
	local holdtime = math.Clamp(self:GetClientNumber("timer", sKeypad.config.GrantedDelay.min), sKeypad.config.GrantedDelay.min, sKeypad.config.GrantedDelay.max)
	local canauthedit = tobool(self:GetClientNumber("authcanedit"))
	local inverse = tobool(self:GetClientNumber("inverse"))
	local mode = self:GetClientNumber("mode")
	local owner = self:GetOwner()

	local ent, pos = trace.Entity, trace.HitPos + trace.HitNormal

	if pos then
		if !IsValid(self.targetEnt) then
			if !sKeypad.config.WhitelistedEnts[ent:GetClass()] or !IsValid(ent) then return false end
			self.targetEnt = ent
		else
			local ang = trace.HitNormal:Angle()

			if SERVER then
				if ent:GetClass() ~= "s_keypad" then
					if self.targetEnt.keypads and table.Count(self.targetEnt.keypads) >= sKeypad.config.MaxPerDoor then return false end

					local kp = ents.Create("s_keypad")
					kp:SetAngles(ang)
					kp:SetPos(pos - kp:GetUp() * 2)
					kp:SetCreator(owner)
					kp:Spawn()

					local phys = kp:GetPhysicsObject()

					if IsValid(phys) then phys:EnableMotion(false) end

					kp.data = {
						owner = owner:SteamID(),
						timer = holdtime,
						code = pw,
						toggle = inverse,
						mode = mode,
						canauthedit = canauthedit,
						doors = {[self.targetEnt] = true},
						authed = {},
						upgrades = {}
					}

					kp:SetBodygroup( 2, mode )

					undo.Create("s_keypad")
					undo.AddEntity(kp)
					undo.SetPlayer(owner)
					undo.Finish()

					constraint.Weld(kp, self.targetEnt, 0, 0, 0, true, false)

					self.targetEnt.keypads = self.targetEnt.keypads or {}
					self.targetEnt.keypads[kp] = true

					local stop = false

					for k, v in pairs(self.targetEnt.keypads) do
						if k:GetSkin() == 1 then kp:SetSkin(1) stop = true end
					end

					if !stop then
						kp:CloseDoor()
					end
				else
					local data = ent.data

					if data then
						if data.doors then
							data.doors[self.targetEnt] = true
						end
					end

					if ent.data.toggle then
						sKeypad.fadeDoor(self.targetEnt)
					end

					self.targetEnt.keypads = self.targetEnt.keypads or {}
					self.targetEnt.keypads[ent] = true
				end
			end

			self.targetEnt = nil
		end
	end

	return true
end

function TOOL:DrawHUD()
	local trace = LocalPlayer():GetEyeTrace()
	local ent = trace.Entity

	if !IsValid(self.targetEnt) then
		if sKeypad.config.EnableHalos and ent ~= NULL and IsValid(ent) and sKeypad.config.WhitelistedEnts[ent:GetClass()] then
			hoverHalos = {ent}
		else
			hoverHalos = {}
		end
	elseif sKeypad.config.EnableLinkBeam then
		if IsValid(ent) and ent:GetClass() == "s_keypad" then
			cam.Start3D(EyePos(), EyeAngles())
				render.SetMaterial(sKeypad.config.BeamMat)
				render.DrawBeam(ent:GetPos(), self.targetEnt:GetPos(), 2, 0.01, 20, sKeypad.config.BeamColor)
			cam.End3D()
		end
	end

end

function TOOL:RightClick( trace )
	if CLIENT then return true end

	for i=1,2 do
		self:LeftClick(trace, true)
	end

	return true
end

function TOOL:Think()
	if !sKeypad.config.EnablKeypadPreview or SERVER then return end
	local trace = LocalPlayer():GetEyeTrace()
	local ent = trace.Entity
	local pos = trace.HitPos + trace.HitNormal

	if IsValid(self.targetEnt) then
		if !IsValid(self.keypadDisplay) and ent:GetClass() ~= "s_keypad" then
			local mode = self:GetClientNumber("mode")

			self.keypadDisplay = ents.CreateClientProp("models/sterling/stromic_skeypad.mdl")
			self.keypadDisplay:SetColor(Color(255,255,255,150))
			self.keypadDisplay:SetRenderMode(RENDERMODE_TRANSCOLOR)
			self.keypadDisplay:SetBodygroup(2, mode)

			self.keypadDisplay:SetAngles(trace.HitNormal:Angle())
			self.keypadDisplay:SetPos(pos - self.keypadDisplay:GetUp() * 2)

			local phys = self.keypadDisplay:GetPhysicsObject()

			if IsValid(phys) then
				phys:EnableMotion(false)
			end
		end

		if ent:GetClass() == "s_keypad" and IsValid(self.keypadDisplay) then
			self.keypadDisplay:Remove()
		end
	else
		if IsValid(self.keypadDisplay) then
			self.keypadDisplay:Remove()
		end
	end


	if !IsValid(self.keypadDisplay) then return end

	local mode = self:GetClientNumber("mode")

	local trace = LocalPlayer():GetEyeTrace()
	local pos = trace.HitPos
	local angles = trace.HitNormal:Angle()
	self.keypadDisplay:SetPos(pos - self.keypadDisplay:GetUp() * 2)
	self.keypadDisplay:SetAngles(angles)
	self.keypadDisplay:SetBodygroup(2, mode)
end

function TOOL:Holster()
	if IsValid(self.keypadDisplay) then
		self.keypadDisplay:Remove()
	end

	self.targetEnt = nil

	return true
end

function TOOL.BuildCPanel(panel)
	local banner = vgui.Create("EditablePanel", panel)
	banner:SetTall(200)

	banner.Paint = function(s,w,h)
		local color =  HSVToColor(  ( CurTime() * 10 ) % 360, 1, 1 )
		color.a = 60
		surface.SetDrawColor( sKeypad.config.UI["maincolor"] )
		surface.DrawRect( 0, 0, w, h )

		surface.SetMaterial( gradient )
		surface.SetDrawColor(color)
		surface.DrawTexturedRect( 0, 0, w, h )

		surface.SetMaterial( logo )
		surface.SetDrawColor( white )
		surface.DrawTexturedRect( w * .5 - 64, h * .5 - 64, 128, 128 )
	end

	panel:AddItem(banner)

	panel:AddControl( "Header", { Description = slib.getLang("skeypad", sKeypad.config.Language, "tool_usage") } )

	local selectionWidth = math.floor(ScrH() * 0.04)

	local selection = vgui.Create("EditablePanel")
	selection:Dock(TOP)
	selection:DockPadding(0,0,0,3)
	selection:SetTall(selectionWidth)

	local selectedMode

	local keycode = vgui.Create("DButton", selection)
	keycode:Dock(LEFT)
	keycode:DockMargin(0,0,3,0)
	keycode:SetWide(selectionWidth)
	keycode:SetText("")

	keycode.Paint = function(s,w,h)
		local size = w * .8

		surface.SetDrawColor(selectedMode == s and green or sKeypad.config.UI["maincolor"])
		surface.DrawOutlinedRect(0,0,w,h)

		surface.SetMaterial( keycodeMat )
		surface.SetDrawColor( white )
		surface.DrawTexturedRect( w * .5 - (size * .5), h * .5 - (size * .5), size, size )
	end

	keycode.DoClick = function()
		selectedMode = keycode
		RunConsoleCommand("skeypad_mode", 0)
	end

	local fingerprint = vgui.Create("DButton", selection)
	fingerprint:Dock(LEFT)
	fingerprint:SetWide(selectionWidth)
	fingerprint:SetText("")

	fingerprint.Paint = function(s,w,h)
		local size = w * .8

		surface.SetDrawColor(selectedMode == s and green or sKeypad.config.UI["maincolor"])
		surface.DrawOutlinedRect(0,0,w,h)

		surface.SetMaterial( fingerprintMat )
		surface.SetDrawColor( white )
		surface.DrawTexturedRect( w * .5 - (size * .5), h * .5 - (size * .5), size, size )
	end

	fingerprint.DoClick = function()
		selectedMode = fingerprint
		RunConsoleCommand("skeypad_mode", 1)
	end

	local toolsettings = LocalPlayer():GetTool("skeypad")
	local mode = toolsettings:GetClientNumber("mode")

	if mode == 0 then
		selectedMode = keycode
	elseif mode == 1 then
		selectedMode = fingerprint
	end

	panel:AddItem(selection)

	local holdlength = panel:NumSlider(slib.getLang("skeypad", sKeypad.config.Language, "hold_length"), "skeypad_timer", 5, 30, 2)
	holdlength:SetMin(sKeypad.config.GrantedDelay.min)
	holdlength:SetMax(sKeypad.config.GrantedDelay.max)

	local code = panel:TextEntry(slib.getLang("skeypad", sKeypad.config.Language, "access_code"), "skeypad_pw")
	code:SetNumeric(true)

	code.OnChange = function()
		local text = code:GetValue() or ""
		if text and text:len() > 4 then
			code:SetText(text:sub(1,text:len()-1))
			TextEntryLoseFocus()
			notification.AddLegacy(slib.getLang("skeypad", sKeypad.config.Language, "max_4digit"), NOTIFY_GENERIC, 3)
		end
	end

	panel:ControlHelp(slib.getLang("skeypad", sKeypad.config.Language, "4digit_passcode"))

	panel:AddControl( "CheckBox", { Label = slib.getLang("skeypad", sKeypad.config.Language, "start_faded"), Command = "skeypad_inverse" } )
	panel:ControlHelp(slib.getLang("skeypad", sKeypad.config.Language, "start_faded_help"))

	panel:AddControl( "CheckBox", { Label = slib.getLang("skeypad", sKeypad.config.Language, "auth_cansettings"), Command = "skeypad_authcanedit" } )
	panel:ControlHelp(slib.getLang("skeypad", sKeypad.config.Language, "auth_cansettings_help"))

	panel:AddControl( "CheckBox", { Label = slib.getLang("skeypad", sKeypad.config.Language, "hide_passcode"), Command = "skeypad_hidecode" } )
	panel:ControlHelp(slib.getLang("skeypad", sKeypad.config.Language, "hide_passcode_help"))
end

function TOOL:DrawToolScreen( w, h )
	local color = HSVToColor(  ( CurTime() * 10 ) % 360, 1, 1 )
	color.a = 60
	surface.SetDrawColor( sKeypad.config.UI["maincolor"] )
	surface.DrawRect( 0, 0, w, h )

	surface.SetMaterial( gradient )
	surface.SetDrawColor(color)
	surface.DrawTexturedRect( 0, 0, w, h )

	draw.SimpleText( "sKeypad", slib.createFont("Nasalization Rg", 40), w * .5, h * .5, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

hook.Add("PreDrawHalos", "sK:DrawHaloOnHover", function()
	local ply = LocalPlayer()
	if !sKeypad.config.EnableHalos or !IsValid(ply) then return end
	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) then return end
	if wep:GetClass() ~= "gmod_tool" then hoverHalos = {} end
	halo.Add( hoverHalos, sKeypad.config.HaloColor, 0, 0, 2, true )
end )

if CLIENT then
	timer.Create("sK:CheckToolMode", 1, 0, function()
		local ply = LocalPlayer()
		if !IsValid(ply) then return end
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) and weapon:GetClass() == "gmod_tool" and weapon:GetTable().current_mode ~= "skeypad" then
			hoverHalos = {}
		end
	end)
end

-- vk.com/urbanichka