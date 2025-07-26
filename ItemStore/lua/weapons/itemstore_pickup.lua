if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Инвентарь"

SWEP.Purpose = "Собираем вещи"
SWEP.Instructions = "ПКМ, Забрать предмет. ЛКМ, Открыть инвентарь"
SWEP.Category = "Scora"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Slot               = 1
SWEP.SlotPos 			= 10
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = true

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	self.Owner:PickupItem()
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	self.Owner:OpenContainer( self.Owner.Inventory:GetID(),
		itemstore.Translate( "inventory" ), true )
end
