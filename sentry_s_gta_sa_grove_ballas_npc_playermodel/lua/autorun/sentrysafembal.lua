player_manager.AddValidModel( "Sentry's BALLAS Member1", "models/sentry/senfembal/sentrybal1male3pm.mdl" )
player_manager.AddValidModel( "Sentry's BALLAS Member2", "models/sentry/senfembal/sentrybal2male3pm.mdl" )
player_manager.AddValidModel( "Sentry's BALLAS Member3", "models/sentry/senfembal/sentrybal3male1pm.mdl" )
player_manager.AddValidModel( "Sentry's GROVE Member1", "models/sentry/senfembal/sentryfem1male3pm.mdl" )
player_manager.AddValidModel( "Sentry's GROVE Member2", "models/sentry/senfembal/sentryfem2male1pm.mdl" )
player_manager.AddValidModel( "Sentry's GROVE Member3", "models/sentry/senfembal/sentryfem3male1pm.mdl" )

player_manager.AddValidHands( "Sentry's BALLAS Member1", "models/sentry/senfembal/senfembalhand.mdl", 0, "00000000" )
player_manager.AddValidHands( "Sentry's BALLAS Member2", "models/sentry/senfembal/senbal2hand.mdl", 0, "00000000" )
player_manager.AddValidHands( "Sentry's BALLAS Member3", "models/sentry/senfembal/senbal3hand.mdl", 0, "00000000" )
player_manager.AddValidHands( "Sentry's GROVE Member1", "models/sentry/senfembal/senfem1hand.mdl", 0, "00000000" )
player_manager.AddValidHands( "Sentry's GROVE Member2", "models/sentry/senfembal/senfem2hand.mdl", 0, "00000000" )
player_manager.AddValidHands( "Sentry's GROVE Member3", "models/sentry/senfembal/senfembalhand.mdl", 0, "00000000" )

local nextName
local tbNPCs = {}

local function AddNPC(category, name, class, model, keyvalues, weapons, spawnflags)
		list.Set("NPC",name,{Name = name,Class = class,Model = model,Category = category,KeyValues = keyvalues,Weapons = weapons, SpawnFlags = spawnflags})
		tbNPCs[name] = model
end

AddNPC("SENTRY's Model", "BALLAS Member1", "npc_citizen", "models/sentry/senfembal/sentrybal1male3g.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})
AddNPC("SENTRY's Model", "BALLAS Member1 (Hostile)", "npc_combine_s", "models/sentry/senfembal/sentrybal1male3h.mdl", {citizentype = CT_UNIQUE, SquadName = "us"}, {"weapon_shotgun","weapon_smg1"})
AddNPC("SENTRY's Model", "BALLAS Member2", "npc_citizen", "models/sentry/senfembal/sentrybal2male3g.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})
AddNPC("SENTRY's Model", "BALLAS Member2 (Hostile)", "npc_combine_s", "models/sentry/senfembal/sentrybal2male3h.mdl", {citizentype = CT_UNIQUE, SquadName = "us"}, {"weapon_shotgun","weapon_smg1"})
AddNPC("SENTRY's Model", "BALLAS Member3", "npc_citizen", "models/sentry/senfembal/sentrybal3male1g.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})
AddNPC("SENTRY's Model", "BALLAS Member3 (Hostile)", "npc_combine_s", "models/sentry/senfembal/sentrybal3male1h.mdl", {citizentype = CT_UNIQUE, SquadName = "us"}, {"weapon_shotgun","weapon_smg1"})
AddNPC("SENTRY's Model", "GROVE Member1", "npc_citizen", "models/sentry/senfembal/sentryfem1male3g.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})
AddNPC("SENTRY's Model", "GROVE Member1 (Hostile)", "npc_combine_s", "models/sentry/senfembal/sentryfem1male3h.mdl", {citizentype = CT_UNIQUE, SquadName = "us"}, {"weapon_shotgun","weapon_smg1"})
AddNPC("SENTRY's Model", "GROVE Member2", "npc_citizen", "models/sentry/senfembal/sentryfem2male1g.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})
AddNPC("SENTRY's Model", "GROVE Member2 (Hostile)", "npc_combine_s", "models/sentry/senfembal/sentryfem2male1h.mdl", {citizentype = CT_UNIQUE, SquadName = "us"}, {"weapon_shotgun","weapon_smg1"})
AddNPC("SENTRY's Model", "GROVE Member3", "npc_citizen", "models/sentry/senfembal/sentryfem3male1g.mdl", {citizentype = CT_UNIQUE, SquadName = "rebels"}, {"weapon_pistol","weapon_smg1"})
AddNPC("SENTRY's Model", "GROVE Member3 (Hostile)", "npc_combine_s", "models/sentry/senfembal/sentryfem3male1h.mdl", {citizentype = CT_UNIQUE, SquadName = "us"}, {"weapon_shotgun","weapon_smg1"})
