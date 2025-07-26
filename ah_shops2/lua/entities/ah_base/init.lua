--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "addArmor_send" )

function ENT:Initialize( )
	self:SetModel( self.model )
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid( SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
	self:SetCollisionGroup( 1 )
end

function ENT:AcceptInput( key, ply )	

	if ply.AlloweNextFire_AhShop == nil then ply.AlloweNextFire_AhShop = true end

	if ( ( self.lastUsed or CurTime() ) <= CurTime() ) then
		self.lastUsed = CurTime() + 0.25
		if ( key == "Use" && ply:IsPlayer() && IsValid( ply ) && ply.AlloweNextFire_AhShop ) then	
			net.Start( "addArmor_send" )
			net.WriteEntity( self )
			net.Send( ply )			
		end		
	end	
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
