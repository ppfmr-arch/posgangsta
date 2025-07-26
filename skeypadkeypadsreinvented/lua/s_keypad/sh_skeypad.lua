local imgui = include("s_keypad/client/imgui.lua")

for k, v in pairs(sKeypad.config.keypads) do
	local SWEP = {Primary = {}, Secondary = {}}

	if CLIENT then
		SWEP.PrintName = k
		SWEP.Slot = 4
		SWEP.SlotPos = 1
		SWEP.DrawAmmo = false
		SWEP.DrawCrosshair = true
	end

	SWEP.Author = "Stromic"
	SWEP.Instructions = "Primary fire to crack a keypad!"
	SWEP.Contact = ""
	SWEP.Purpose = ""
	SWEP.Category = "sKeypad"
	SWEP.AnimPrefix = "python"

	SWEP.Spawnable = true
	SWEP.AdminOnly = false

	SWEP.ViewModelFOV = v.fov
	SWEP.ViewModelFlip = false
	SWEP.ViewModel = Model(v.v_mdl)
	SWEP.WorldModel = Model(v.w_mdl)

	SWEP.Primary.ClipSize = -1
	SWEP.Primary.DefaultClip = 0
	SWEP.Primary.Automatic = false
	SWEP.Primary.Ammo = ""

	SWEP.Secondary.ClipSize = -1
	SWEP.Secondary.DefaultClip = -1
	SWEP.Secondary.Automatic = false
	SWEP.Secondary.Ammo = ""

	SWEP.IdleStance = "slam"

	function SWEP:Initialize()
		self:SetHoldType(self.IdleStance)
	end

	function SWEP:PrimaryAttack()
		self:SetNextPrimaryFire(CurTime() + 0.5)
		local owner = self.Owner


		if !IsValid(owner) then return end

		local trace = owner:GetEyeTrace()
		local ent = trace.Entity

		if IsValid(ent) and trace.HitPos:Distance(owner:GetShootPos()) <= 50 and ent.IsKeypad and !self.IsCracking then
			self.CrackingEnt = ent
			self.IsCracking = true
			self.Finish = CurTime() + v.cracktime

			timer.Create("sK:crackerHandeling_"..self:EntIndex(), v.cracktime, 1, function()
				if self.IsCracking then
					self:Succeed()
				end
			end)

			if SERVER then
				self:EmitSound(v.cracksound, 100, 100)
				timer.Create("sK:crackerSound_"..self:EntIndex(), 1, v.cracktime, function()
					if IsValid(self) and self.IsCracking then
						self:EmitSound(v.cracksound, 100, 100)
					end
				end)
			end
		end
	end

	function SWEP:SecondaryAttack()
		if !SERVER or !v.deployable then return end
		self:SetNextSecondaryFire(CurTime() + 0.5)
		local owner = self.Owner

		if !IsValid(owner) then return end

		local trace = owner:GetEyeTrace()
		local ent = trace.Entity

		if IsValid(ent) and trace.HitPos:Distance(owner:GetShootPos()) <= 50 and ent.IsKeypad then
			if IsValid(ent.beingCracked) and ent.beingCracked.cracking then return end

			owner:StripWeapon(v.classname)

			local deployed_cracker = ents.Create("s_deployable_cracker")
			deployed_cracker:setData(ent, v)
			deployed_cracker:Spawn()

			ent.beingCracked = deployed_cracker
		end
	end

	function SWEP:Holster()
		if SERVER then
			timer.Remove("sK:crackerSound_"..self:EntIndex())
			timer.Remove("sK:crackerHandeling_"..self:EntIndex())
		end

		return true
	end

	function SWEP:Succeed()
		self.Finish = nil
		self.IsCracking = false
		self.CrackingEnt = nil

		if !SERVER then return end

		local trace = self.Owner:GetEyeTrace()
		local ent = trace.Entity

		if SERVER and IsValid(ent) and trace.HitPos:Distance(self.Owner:GetShootPos()) <= 50 and ent.IsKeypad then
			if isfunction(ent.Spark) then
				ent:Spark()
			end

			ent:Process(true)
		end

		timer.Remove("sK:crackerHandeling_"..self:EntIndex())
		timer.Remove("sK:crackerSound_"..self:EntIndex())
		timer.Remove("sK:dots_"..self:EntIndex())
	end

	function SWEP:Fail()
		self.Finish = nil
		self.IsCracking = false

		if !SERVER then return end

		if self and self.CrackingEnt and isfunction(self.CrackingEnt.Alarm) then
			self.CrackingEnt:Alarm()
		end

		timer.Remove("sK:crackerHandeling_"..self:EntIndex())
		timer.Remove("sK:crackerSound_"..self:EntIndex())
		timer.Remove("sK:dots_"..self:EntIndex())
		self.CrackingEnt = nil
	end

	function SWEP:Think()
		if self.IsCracking then
			if IsValid(self.Owner) then
				local trace = self.Owner:GetEyeTrace()

				if !IsValid(trace.Entity) or !trace.Entity.IsKeypad or trace.HitPos:Distance(self.Owner:GetShootPos()) > 50 or (self.CrackingEnt ~= trace.Entity) then
					self:Fail()
				end
			end
		end
	end

	if CLIENT then
		function SWEP:PostDrawViewModel(ent, player, weapon)
			weapon.dots = weapon.dots or ""

			if !timer.Exists("sK:dots_"..weapon:EntIndex()) then
				timer.Create("sK:dots_"..weapon:EntIndex(), .75, 0, function()
					if #weapon.dots >= 3 then weapon.dots = "" return end
					weapon.dots = weapon.dots.."."
				end)
			end

			local pos, ang = ent:LocalToWorld(Vector(14, 0.14, -3)), ent:LocalToWorldAngles(Angle(0.966, -95, 47.12))
			cam.Start3D2D(pos, ang, 0.0085)
				if self.IsCracking then
					local defaultStart = self.Finish - v.cracktime

					local wantedcolor = ((CurTime() - defaultStart) * 100) / (self.Finish - defaultStart)

					if wantedcolor > 90 then
						wantedcolor = slib.getTheme("successcolor")
					elseif wantedcolor > 30 then
						wantedcolor = slib.getTheme("orangecolor")
					else
						wantedcolor = slib.getTheme("failcolor")
					end

					self.CrackColor = self.CrackColor or wantedcolor
					self.CrackColor.r = Lerp(RealFrameTime() * 3, wantedcolor.r, self.CrackColor.r)
					self.CrackColor.g = Lerp(RealFrameTime() * 3, wantedcolor.g, self.CrackColor.g)
					self.CrackColor.b = Lerp(RealFrameTime() * 3, wantedcolor.b, self.CrackColor.b)

					draw.SimpleText(slib.getLang("skeypad", sKeypad.config.Language, "cracking")..weapon.dots, slib.createFont("Digital dream", 24, 700), 0, 0, self.CrackColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(slib.getLang("skeypad", sKeypad.config.Language, "awaiting"), slib.createFont("Digital dream", 24, 700), 0, 0, slib.getTheme("orangecolor"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			cam.End3D2D()
		end
	end

	weapons.Register( SWEP, v.classname )
end

-- vk.com/urbanichka