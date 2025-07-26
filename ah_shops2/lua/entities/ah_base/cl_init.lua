--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

include("shared.lua")

surface.CreateFont( "ah_font", {
	font = "cantarell_regular", 
	size = 30,
	weight = 800,
	antialias = true,
} )

function ENT:Draw()

	self:DrawModel()
	
	local dist = self:GetPos():Distance(EyePos())
	local clam = math.Clamp(dist, 0, 255 )
	local main = (255 - clam)
	
	if (main <= 0) then return end
	
	local ahAngle = self:GetAngles()
	local AhEyes = LocalPlayer():EyeAngles()
	local colr = self:GetThemeColor()
	local text = self:GetHeaderText()
	
	ahAngle:RotateAroundAxis(ahAngle:Forward(), 90)
	ahAngle:RotateAroundAxis(ahAngle:Right(), -90)		
	
	cam.Start3D2D(self:GetPos()+self:GetUp()*80, Angle(0, AhEyes.y-90, 90), 0.175)
	
		surface.SetDrawColor( Color(colr.x,colr.y,colr.z,main) )
		draw.SimpleTextOutlined(text, "ah_font", 0, 13, Color(colr.x,colr.y,colr.z,main), 1, 0, 1, Color(25, 25, 25, main))
		
	cam.End3D2D()	
	
end		

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
