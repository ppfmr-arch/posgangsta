BM2CONFIG = {}

//Setting this to false will disable the generator from making sound.
BM2CONFIG.GeneratorsProduceSound = true

//Dollas a bitcoins sells for. Dont make this too large or it will be too easy to make money
BM2CONFIG.BitcoinValue = 8500

//This is a value that when raising or lowering will effect the speed of all bitminers.
//This is a balanced number and you should only change it if you know you need to. Small increments make big differences
BM2CONFIG.BaseSpeed = 0.004

//The higher this number, the faster the generator will loose fuel.
//You can use this to balance out more so they need to buy fuel more frequently
BM2CONFIG.BaseFuelDepletionRate = 0.9




hook.Add("PostGamemodeLoaded", "BM2.SetupEntities", function()
	DarkRP.createCategory{
		name = "Bitminers 2",
		categorises = "entities",
		startExpanded = true,
		color = Color(120, 120, 255, 255),
		sortOrder = 1,
	}

	DarkRP.createEntity("Bitminer S1", {
		ent = "bm2_bitminer_1",
		model = "models/bitminers2/bitminer_1.mdl",
		price = 5000,
		max = 4,
		cmd = "buybitminers1",
		category = "Bitminers 2"
	}) 

	DarkRP.createEntity("Bitminer S2", {
		ent = "bm2_bitminer_2",
		model = "models/bitminers2/bitminer_3.mdl",
		price = 25000,
		max = 4,
		cmd = "buybitminers2",
		category = "Bitminers 2"
	})

	DarkRP.createEntity("Bitminer Server", {
		ent = "bm2_bitminer_server",
		model = "models/bitminers2/bitminer_2.mdl",
		price = 50000,
		max = 16,
		cmd = "buybitminerserver",
		category = "Bitminers 2"
	})

	DarkRP.createEntity("Bitminer Rack", {
		ent = "bm2_bitminer_rack",
		model = "models/bitminers2/bitminer_rack.mdl",
		price = 100000,
		max = 2,
		cmd = "buybitminerrack",
		category = "Bitminers 2"
	})

	DarkRP.createEntity("Extension Lead", {
		ent = "bm2_extention_lead",
		model = "models/bitminers2/bitminer_plug_3.mdl",
		price = 500,
		max = 8,
		cmd = "buybitminerextension",
		category = "Bitminers 2"
	})

	DarkRP.createEntity("Power Lead", {
		ent = "bm2_power_lead",
		model = "models/bitminers2/bitminer_plug_2.mdl",
		price = 500,
		max = 10,
		cmd = "buybitminerpowerlead",
		category = "Bitminers 2"
	})

	DarkRP.createEntity("Generator", {
		ent = "bm2_generator",
		model = "models/bitminers2/generator.mdl",
		price = 6000,
		max = 3,
		cmd = "buybitminergenerator",
		category = "Bitminers 2"
	})

	DarkRP.createEntity("Fuel", {
		ent = "bm2_fuel",
		model = "models/props_junk/gascan001a.mdl",
		price = 1000,
		max = 4,
		cmd = "buybitminerfuel",
		category = "Bitminers 2"
	})
end)