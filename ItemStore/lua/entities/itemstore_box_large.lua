ENT.Type = "anim"
ENT.Base = "itemstore_box"

ENT.PrintName = "Большая Коробка"
ENT.Category = "Scora"

ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
	AddCSLuaFile()

	ENT.Model = "models/props/cs_office/cardboard_box01.mdl"

	ENT.ContainerWidth = 5
	ENT.ContainerHeight = 4
	ENT.ContainerPages = 1
end
