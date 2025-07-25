player_manager.AddValidModel( "Los Santos Vagos 1", "models/gtasa/lsv1pm.mdl" )
player_manager.AddValidModel( "Los Santos Vagos 2", "models/gtasa/lsv2pm.mdl" )
player_manager.AddValidModel( "Los Santos Vagos 3", "models/gtasa/lsv3pm.mdl" )


local modelsvg = {
	lsvgood = {
		"models/gtasa/lsv1.mdl",
		"models/gtasa/lsv2.mdl",
		"models/gtasa/lsv3.mdl"
	}
}
local modelsvb = {
	lsvbad = {
		"models/gtasa/lsv1b.mdl",
		"models/gtasa/lsv2b.mdl",
		"models/gtasa/lsv3b.mdl"
	}
}
local nextName
local tbNPCs = {}

hook.Add("PlayerSpawnNPC", "lossantosvagosSpawnGetName", function(ply, name) nextName = name end)

hook.Add("PlayerSpawnedNPC", "lossantosvagosSpawnSetRandomModel", function(ply, npc)
	if (!nextName) then return end
	if (tbNPCs[nextName]) then
			local min, max = npc:GetCollisionBounds()
			local hull = npc:GetHullType()
			if (nextName == "Los Santos Vagos (Hostile)") then
				npc:SetModel(table.Random(modelsvb.lsvbad))
			end
			if (nextName == "Los Santos Vagos (Friendly)") then
				npc:SetModel(table.Random(modelsvg.lsvgood))
			end
		npc:SetSolid(SOLID_BBOX)
		npc:SetHullType(hull)
		npc:SetHullSizeNormal()
		npc:SetCollisionBounds(min,max)
		npc:DropToFloor()
		end
	nextName = nil
end)

local function AddNPC(category, name, class, model, keyvalues, weapons, spawnflags)
		list.Set("NPC",name,{Name = name,Class = class,Model = model,Category = category,KeyValues = keyvalues,Weapons = weapons, SpawnFlags = spawnflags})
		tbNPCs[name] = model
end

AddNPC("LSV", "Los Santos Vagos (Hostile)", "npc_metropolice", "models/gtasa/lsv1b.mdl", {citizentype = CT_UNIQUE, SquadName = "combine"}, {"weapon_pistol","weapon_smg1"})

AddNPC("LSV", "Los Santos Vagos (Friendly)", "npc_citizen", "models/gtasa/lsv1.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})


















