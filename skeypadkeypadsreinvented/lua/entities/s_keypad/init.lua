include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

sound.Add( {
	name = "keypad_alarm",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = sKeypad.config.AlarmSound
} )

function ENT:Initialize()
	self:SetModel("models/sterling/stromic_skeypad.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	self:SetBodygroup( 1, 1 )

	self.health = 100
end

function ENT:OnRemove()
	local doors = self.data.doors

	self.data.toggle = false
	self:CloseDoor()

	if doors then
		for k, v in pairs(doors) do
			if !k.keypads then continue end
			k.keypads[self] = nil
		end
	end
end

function ENT:Alarm()
	if !self.data.upgrades["alarm"] or sKeypad.config.Upgrades["alarm"].price <= -1 or self.alarm then return end
	self.alarm = true

	self:SetSkin(2)
	self:EmitSound("keypad_alarm")
	timer.Create(self:EntIndex().."_Alarm", .5, 0, function()
		if !IsValid(self) then return end

		local curskin = self:GetSkin()
		self:SetSkin(curskin == 0 and 2 or 0)
		self:EmitSound("buttons/blip1.wav")
	end)

	timer.Simple(sKeypad.config.alarmTimer, function()
		if !IsValid(self) then return end

		if timer.Exists(self:EntIndex().."_Alarm") then
			timer.Remove(self:EntIndex().."_Alarm")
		end

		self.alarm = nil

		self:SetSkin(0)
		self:StopSound("keypad_alarm")
	end)

	sKeypad.Notify(player.GetBySteamID(self.data.owner), sKeypad.languages[sKeypad.config.Language]["triggered_alarm"])
end

function ENT:Spark()
	local vPoint = self:GetPos()
	vPoint.z = vPoint.z + 5
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	effectdata:SetMagnitude( 2 )
	effectdata:SetRadius(2)
	effectdata:SetScale(1)
	util.Effect( "Sparks", effectdata )

	self:EmitSound("ambient/energy/zap"..math.random(1,3)..".wav")
end

function ENT:OnTakeDamage(dmginfo)
	if !sKeypad.config.breakable then return end

	local amount = dmginfo:GetDamage()
	
	if sKeypad.config.Upgrades["armor"].price > -1 then
		amount = amount * (self.data.upgrades.armor and .3 or 1)
	end

	self.health = self.health - amount
	if self.health <= 0 and !self.broken then
		self.broken = true
		self:SetSkin(2)
		self:Spark()
		
		timer.Create(self:EntIndex().."effectsBroken", .9, 0, function()
			if !IsValid(self) then return end

			if !self.broken then timer.Remove(self:EntIndex().."effectsBroken") return end
			self:Spark()
		end)

		timer.Simple(istable(sKeypad.config.brokenTimeout) and math.random(sKeypad.config.brokenTimeout.min, sKeypad.config.brokenTimeout.max) or sKeypad.config.brokenTimeout, function()
			if !IsValid(self) then return end

			self:EmitSound("buttons/button1.wav")

			self:SetSkin(0)
			self.health = 100
			self.broken = nil
		end)
	end
end

function ENT:OpenDoor()
	local doors = self.data.doors
	if !doors then return end

	for k,v in pairs(doors) do
		if !IsValid(k) then continue end

		if k.keypads then
			for i, z in pairs(k.keypads) do
				if !IsValid(i) then continue end
				i:SetSkin(1)
			end
		end

		if self.data.toggle then
			sKeypad.unFadeDoor(k)
		else
			sKeypad.fadeDoor(k)
		end
	end
end

function ENT:CloseDoor()
	local doors = self.data.doors
	if !doors then return end

	for k,v in pairs(doors) do
		if !IsValid(k) then continue end
		
		if k.keypads then
			for i, z in pairs(k.keypads) do
				if !IsValid(i) then continue end
				i:SetSkin(0)
			end
		end

		if self.data.toggle then
			sKeypad.fadeDoor(k)
		else
			sKeypad.unFadeDoor(k, self)
		end
	end
end

function ENT:Shock(ply)
	local hp = ply:Health()
	local damage = math.random(sKeypad.config.ShockDamageRange.min, sKeypad.config.ShockDamageRange.max)

	self:Spark()

	ply:ScreenFade(SCREENFADE.IN, Color(255,255,255, 200), 0.9, 0)

	ply:SetHealth(hp - damage)
	
	if (hp - damage) <= 0 then ply:Kill() end
end

function ENT:AccessGranted()
	if !IsValid(self) then return end
	local doors = self.data.doors
	local time = math.Clamp(self.data.timer, sKeypad.config.GrantedDelay.min, sKeypad.config.GrantedDelay.max)

	self:EmitSound( sKeypad.config.GrantedSound, 75, 100, 1, CHAN_AUTO )
	self:SetSkin(1)

	self:OpenDoor()

	timer.Simple(time, function()
		if !IsValid(self) then return end
		self:SetSkin(0)
		self:CloseDoor()
	end)

	hook.Run("sK:AccessGranted", ply, self)
end

function ENT:AccessDenied(ply)
	if sKeypad.config.Upgrades["shock"].price > -1 and self.data.upgrades["shock"] and IsValid(ply) and ply:IsPlayer() then
		self:Shock(ply)
	end

	self:EmitSound( sKeypad.config.DeniedSound, 75, 100, 1, CHAN_AUTO )
	self:SetSkin(2)

	timer.Simple(sKeypad.config.DeniedTimeout, function()
		if !IsValid(self) then return end
		self:SetSkin(0)
	end)

	hook.Run("sK:AccessDenied", ply, self)
end

function ENT:AttemptAuthenticate(ply, code)
	if self:GetSkin() ~= 0 or self.broken or self.alarm then return end
	if self:GetBodygroup(2) == 0 and code then
		if self.data.code == code then
			self:AccessGranted()
		else
			self:AccessDenied(ply)
		end
	elseif self:GetBodygroup(2) == 1 then
		if self:IsAuthorized(ply) then
			self:AccessGranted()
		else
			self:AccessDenied(ply)
		end
	end
end

function ENT:IsAuthorized(ply)
	local result = false
	local data = self.data
	local sid = ply:SteamID()
	local owner = (player.GetBySteamID(data.owner))

	if data.owner == sid or data.authed[sid] then result = true end
	
	if DarkRP then
		if data.authed[ply:getDarkRPVar("job")] then return true end
	end

	if data.authed["gang"] then
		if mg2 and isfunction(ply.GetGangGroup) and isfunction(owner.GetGangGroup) then
			if ply:GetGangGroup() == owner:GetGangGroup() then
				return true
			end
		end
	end

	if data.authed["party"] then
		if isfunction(isInParty) and sPartySystem then
			local isinparty1, partyname1 = isInParty(ply)
			local isinparty2, partyname2 = isInParty(owner)

			if partyname1 == partyname2 then
				return true
			end
		end

		if party and isfunction(ply.GetParty) and isfunction(owner.GetParty) then
			if ply:GetParty() == owner:GetParty() then
				return true
			end
		end

		if isfunction(whatBlobParty) and BlobsPartyConfig then
			if whatBlobParty(ply) == whatBlobParty(owner) and whatBlobParty(ply) then
				result = true
			end
		end
	end

	if data.authed["fppbuddy"] then
		if isfunction(owner.CPPIGetFriends) then
			local friends = owner:CPPIGetFriends()
			if istable(friends) then
				for k,v in pairs(friends) do
					if v == ply then result = true break end
				end
			end
		end
	end

	return result
end

function ENT:SyncSettings(ply)
	local data = self.data
	local settings = util.Compress(util.TableToJSON(data))

	local chunksize = #settings

	net.Start("sK:Handeler")
	net.WriteUInt(1, 2)
	net.WriteEntity(self)
	net.WriteUInt(chunksize, 32)
	net.WriteData(settings, chunksize)
	net.Send(ply)
end

function ENT:OpenSettings(ply)
	local data = self.data
	
	if (!self:IsAuthorized(ply) or !data.canauthedit) and data.owner ~= ply:SteamID() then return end
	if self:GetPos():DistToSqr(ply:GetPos()) > sKeypad.config.MaxDistance then return end

	self:SyncSettings(ply)

	net.Start("sK:Handeler")
	net.WriteUInt(2, 2)
	net.WriteEntity(self)
	net.Send(ply)
end

function ENT:RequestKeycode(ply)
	net.Start("sK:Networking")
	net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Process(b) 
	if SERVER then
		if b then
			self:AccessGranted()
		else
			self:AccessDenied()
		end
	end
end

function ENT:Use(ply)
	if ply:GetEyeTraceNoCursor().Entity ~= self then return end
	self:AttemptAuthenticate(ply)
end

hook.Add("ShowTeam", "sK:OpenSettings", function(ply)
	local ent = ply:GetEyeTraceNoCursor().Entity
	if ent:GetClass() ~= "s_keypad" then return end
	ent:OpenSettings(ply)
end)

hook.Add("canDoorRam", "sK:HandleKeypadRamming", function(ply, trace, ent)
	if ent:GetClass() ~= "s_keypad" then return nil end
	local owner = player.GetBySteamID(ent.data.owner)

	if IsValid(owner) and (owner.warranted == true or owner:isWanted() or owner:isArrested()) then
		ent:AccessGranted()
		return true
	end
end)

-- vk.com/urbanichka