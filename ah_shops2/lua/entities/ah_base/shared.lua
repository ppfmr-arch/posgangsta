--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "ah_base"
ENT.Author = "Mikael"
ENT.Category = "ahshop"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "HeaderText" )
	self:NetworkVar( "String", 1, "TableType" ) 
	self:NetworkVar( "String", 2, "NetWorkId" ) 
	self:NetworkVar( "Vector", 0, "ThemeColor" ) 
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
