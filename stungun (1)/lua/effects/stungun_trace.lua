--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600


AddCSLuaFile()

--[[
Copied from ToolTracer but uses bones instead of attachment for positioning
]]

EFFECT.Mat = Material("effects/tool_tracer")

local vmPosOff = Vector(0, 0, 4)
local wmPosOff = Vector(11, 3.3, 0)

function EFFECT:GetTracerShootPosStungun(Ent)
	if not IsValid(Ent) then return end
	if not Ent:IsWeapon() then return end

	if Ent:IsCarriedByLocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		-- Shoot from the viewmodel
		local ViewModel = LocalPlayer():GetViewModel()

		if not ViewModel:IsValid() then return end

		local bone = ViewModel:LookupBone("x26_groot")
		if not bone then return end

		local m = ViewModel:GetBoneMatrix(bone)
		if not m then return end

		local pos, ang = m:GetTranslation(), m:GetAngles()

		return pos + ang:Forward() * vmPosOff.x + ang:Right() * vmPosOff.y + ang:Up() * vmPosOff.z
	else
		local owner = Ent.Owner
		if not owner then return end

		-- Shoot from the world model
		local bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if not bone then return end

		local m = owner:GetBoneMatrix(bone)
		if not m then return end

		local pos, ang = m:GetTranslation(), m:GetAngles()

		return pos + ang:Forward() * wmPosOff.x + ang:Right() * wmPosOff.y + ang:Up() * wmPosOff.z
	end
end

function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()

	self.StartPos = self:GetTracerShootPosStungun(self.WeaponEnt) or self.Position
	self.EndPos = data:GetOrigin()

	self.Alpha = 255
	self.Life = 0

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 4
	self.Alpha = 255 * (1 - self.Life)

	return self.Life < 1
end

function EFFECT:Render()
	if self.Alpha < 1 then return end

	render.SetMaterial(self.Mat)
	local texcoord = math.Rand(0, 1)

	local norm = (self.StartPos - self.EndPos) * self.Life

	local len = norm:Length()

	for i = 1, 3 do
		render.DrawBeam(self.StartPos - norm,
						self.EndPos,
						8,
						texcoord,
						texcoord + len / 128,
						Color(255, 255, 255))
	end

	render.DrawBeam(self.StartPos,
					self.EndPos,
					8,
					texcoord,
					texcoord + ((self.StartPos - self.EndPos):Length() / 128),
					Color(255, 255, 255, 128 * (1 - self.Life)))
end
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600