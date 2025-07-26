include("shared.lua")

local function drawHandeling(ent)
	if !sKeypad then return end
	
	if ent:GetBodygroup(2) == 0 then
		sKeypad.DrawKeypad(ent)
	end
	
	sKeypad.DrawScreen(ent)
end

function ENT:GetHoveredElement()
	return false
end

function ENT:Draw()
	self:DrawModel()

	drawHandeling(self)
end

-- vk.com/urbanichka