ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Keypad"
ENT.Author = "Stromic"
ENT.Category = "Keypad" 
ENT.Spawnable = true
ENT.IsKeypad = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",1,"State")
	self:NetworkVar("Entity",1,"owning_ent")
end

-- vk.com/urbanichka