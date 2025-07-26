--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

---------------------------------------------------------------------------------
-- Developed by Mikael for Xanath Roleplay from 21-8-2016 to **-**-****        --
-- Mikael ( Mikael ******** ) [ goo.gl/W5SrkB ] ( ID64: 76561198020603627 )    --
-- 								            								   --
-- "Shop Npc"							     								   --
-- Features armor and health selling, features a new plus for your roleplay    --
-- Easy config which everyone can handle.									   --
-- Brings life to your roleplay experience.                					   --
--								              								   --
-- If you wish to contact me:             					   				   --
-- Mikael: mikaelgame@hotmailcom				             				   --
---------------------------------------------------------------------------------
--------------BEFORE YOU START BE SURE TO READ THE README.TXT--------------------
---------------------------------------------------------------------------------
addItems = {}
---------------------------------------------------------------------------------
------------------------------Add Item Explained --------------------------------
---------------------------------------------------------------------------------

--[[
	
	MAIN GUIDE:
	
	Here is a short guide about how to make items and what dealer can see them etc.
	
	We start of by explaining about this first part, what do you place in here?
	Well this determine which npc will sell these items you added to this row.
	
	Every npc have a Id when you create it, you use the id you set to place in here.
	So fx my npc's Id is set to ArmorDealer_1, therefore i place ArmorDealer_1 in the top.
	You are only allowed to use 1 id per row, if you use more, stuff can break.
	
	Here is a picture of my npc create, so it maybe makes more sense in what you need to use from it.
	https://gyazo.com/16e850e11b262e9977abca168eb375aa
	
	addItems["ArmorDealer_1"] = { 
	
	Now we have decided which npc will read our row, in this case the npc we created is set to sell armor.
	You can read more about this in the main/addnpc/addnpc.lua, where it is all explained.
	
	Sinse our npc is set to sell Armor, then there is lot of irrelevant stuff in our row, which we don't need.
	But this doesn't mean you are forced to remove the irrevant stuff from your table, in this case as we sell armor,
	then its "Health", "Item", but mainly you can just leave them in the row, the code will ignore them if they are not used.
	
	But if you want the row to look more organized you can freely remove them from the row, so it will look like this:
	
	addItems["ArmorDealer_1"] = { 
	[1] = {
		Name = "Armor Pack",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50, 
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true }, 
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true} 
	},
	[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
	}
	
	Now lets say you set the npc to sell "Health", then you could have removed "Armor = 50," amd kept "Health = 50,".
	If you are confused about all this, then just keep them in the row.
	
	JOB AND ULX RESTRICTIONS:
	
	If you do not want to restrict a item to a Job/ulx group, then be sure to remove them from the row.
	Mainly so it look like this:
	
		addItems["ArmorDealer_1"] = { 
	[1] = {
		Name = "Armor Pack",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50, 
		Outline = false
	},
	[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Outline = false
	}
	}
	
	Another note, be sure to end every row with a comma, and leave the last one without a comma.
	
]]--

---------------------------------------------------------------------------------
--------------------Add more Items to a row.Item Explained ----------------------
---------------------------------------------------------------------------------

--[[
	HOW TO ADD MORE ITEMS TO A ROW:
	
	It is extremely simple to add new items to a row, lets take an example here.
		
	addItems["ArmorDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Armor Pack",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50, -- If you do not use this row, then remove it entirely from the table.
		Health = 0, -- If you do not use this row, then remove it entirely from the table.
		Item = "", -- If you do not use this row, then remove it entirely from the table.
		Outline = false, --Draw a outline around a box, if its job/ulx restricted.
		Job = {["Medic"] = true, ["Mayor"] = true }, -- If you do not use this row, then remove it entirely from the table.
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true} -- If you do not use this row, then remove it entirely from the table.
	},
	[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
	}
	
	To make a new item, you simply just copy paste the row above:
	
		[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
	
	then we change its number, so it doesnt match the other rows, in this case set it to 3.
	And then we change it bit up, so it contain a different offer.
	
		[3] = {
		Name = "Armor Pack 33",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 120 armor.",
		Price = 5000,
		Armor = 120,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
	
	after editing we add it to the main row.
	
	addItems["ArmorDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Armor Pack",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50, -- If you do not use this row, then remove it entirely from the table.
		Health = 0, -- If you do not use this row, then remove it entirely from the table.
		Item = "", -- If you do not use this row, then remove it entirely from the table.
		Outline = false, --Draw a outline around a box, if its job/ulx restricted.
		Job = {["Medic"] = true, ["Mayor"] = true }, -- If you do not use this row, then remove it entirely from the table.
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true} -- If you do not use this row, then remove it entirely from the table.
	}, 
	[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
		[3] = {
		Name = "Armor Pack 33",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 120 armor.",
		Price = 5000,
		Armor = 120,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
	}
	
	now something is missing, every "}" between rows, there will need to be a comma exept the last one, so it will look like this.
	
		addItems["ArmorDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Armor Pack",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50, -- If you do not use this row, then remove it entirely from the table.
		Health = 0, -- If you do not use this row, then remove it entirely from the table.
		Item = "", -- If you do not use this row, then remove it entirely from the table.
		Outline = false, --Draw a outline around a box, if its job/ulx restricted.
		Job = {["Medic"] = true, ["Mayor"] = true }, -- If you do not use this row, then remove it entirely from the table.
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true} -- If you do not use this row, then remove it entirely from the table.
	}, 
	[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}, --COMMA IS ADDED HERE
		[3] = {
		Name = "Armor Pack 33",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 120 armor.",
		Price = 5000,
		Armor = 120,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	} -- NO COMMA NEEDED HERE AS IT IS THE LAST ONE.
	}
	
	And boom here we got a new item, if you are still confused, there is a youtube guide, which describe it better.
	If you are still confused after, you are welcome to add me on steam.

]]--

---------------------------------------------------------------------------------
---------------------------------Add Item tabs ----------------------------------
---------------------------------------------------------------------------------

addItems["ArmorDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Armor Pack", -- not allowed to delete from row.
		Color = Color( 50, 50, 180 ), -- not allowed to delete from row.
		Model = "models/weapons/w_defuser.mdl", -- not allowed to delete from row.
		Description = "This pack include 50 armor.", -- not allowed to delete from row.
		Price = 450, -- not allowed to delete from row.
		Armor = 50, -- If you do not use this row, then you can remove it entirely from the table.
		Health = 0, -- If you do not use this row, then you can remove it entirely from the table.
		Item = "", -- If you do not use this row, then you can remove it entirely from the table.
		Outline = false, --Draw a outline around a box, if its job/ulx restricted, do not delete this.
		Job = {["Medic"] = true, ["Mayor"] = true }, -- If you do not use this row, then remove it entirely from the table.
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true} -- If you do not use this row, then remove it entirely from the table.
	},
	[2] = {
		Name = "Armor Pack2",
		Color = Color( 50, 50, 180 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 0,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
}

addItems["HealthDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Health Pack",
		Color = Color( 255, 50, 50 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 80,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	},
	[2] = {
		Name = "health Pack2",
		Color = Color( 255, 50, 50 ),
		Model = "models/weapons/w_defuser.mdl",
		Description = "This pack include 50 armor.",
		Price = 450,
		Armor = 50,
		Health = 80,
		Item = "",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
addItems["WeaponDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "M16A4_ACOG",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_dmg_m16ag.mdl",
		Description = "Штурмовая винтовка.",
		Price = 3000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_m16a4_acog",
		Outline = false
	},
	[2] = {
		Name = "Honey Badger",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_aac_honeybadger.mdl",
		Description = "Штурмовая винтовка.",
		Price = 6000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_honeybadger",
		Outline = false
	},
	[3] = {
		Name = "PKM",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_mach_russ_pkm.mdl",
		Description = "Пулемёт.",
		Price = 12000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_pkm",
		Outline = false
	},
}

addItems["WeaponDealer_2"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "AS VAL",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_dmg_vally.mdl",
		Description = "Штурмовая винтовка.",
		Price = 12000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_val",
		Outline = false
	},
	[2] = {
		Name = "F2000",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_fn_f2000.mdl",
		Description = "Штурмовая винтовка.",
		Price = 15000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_f2000",
		Outline = false
	},
	[3] = {
		Name = "FG 42",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_fg42.mdl",
		Description = "Штурмовая винтовка.",
		Price = 25000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_fg42",
		Outline = false
	},
}
addItems["WeaponDealer_3"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Double Barrel",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_double_barrel_shotgun.mdl",
		Description = "дабл хуябл",
		Price = 40000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_dbarrel",
		Outline = false
	},
	[2] = {
		Name = "USAS",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_usas_12.mdl",
		Description = "усас",
		Price = 50000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_usas",
		Outline = false
	},
	[3] = {
		Name = "Spas 12",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_spas_12.mdl",
		Description = "спас",
		Price = 60000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_spas12",
		Outline = false
	},
}
addItems["WeaponDealer_4"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "SVD Dragunov",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_svd_dragunov.mdl",
		Description = "стругунов",
		Price = 70000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_dragunov",
		Outline = false
	},
	[2] = {
		Name = "SVU Dragunov",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_usas_12.mdl",
		Description = "СВУ стругунов",
		Price = 80000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_svu",
		Outline = false
	},
	[3] = {
		Name = "Barret m82",
		Color = Color( 50, 180, 50 ),
		Model = "models/weapons/w_barret_m82.mdl",
		Description = "барретка",
		Price = 100000000,
		Armor = 0,
		Health = 0,
		Item = "m9k_barret_m82",
		Outline = false
	},
}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
addItems["EntitiesDealer_1"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Бургер",
		Color = Color( 180, 180, 50 ),
		Model = "models/burgerplate01/burgerplate01.mdl",
		Description = "Отличная замена полезной еды, нахуй веганов!.",
		Price = 450,
		Armor = 0,
		Health = 0,
		Item = "food_burger",
		Outline = false,
	},
	[2] = {
		Name = "Бекон",
		Color = Color( 180, 180, 50 ),
		Model = "models/bacon01/bacon01.mdl",
		Description = "Отличная замена полезной еды, нахуй веганов!.",
		Price = 330,
		Armor = 0,
		Health = 0,
		Item = "food_burger",
		Outline = false,
	},
	[3] = {
		Name = "Яишница",
		Color = Color( 180, 180, 50 ),
		Model = "models/eggs01/eggs01.mdl",
		Description = "ЕДААААААА!.",
		Price = 200,
		Armor = 0,
		Health = 0,
		Item = "food_egg",
		Outline = false,
	},
	[4] = {
		Name = "Твинки",
		Color = Color( 180, 180, 50 ),
		Model = "models/twinkie01/twinkie01.mdl",
		Description = "Отличная замена полезной еды!.",
		Price = 130,
		Armor = 0,
		Health = 0,
		Item = "food_twinkie",
		Outline = false,
	},
	[5] = {
		Name = "Шоколадный шейк",
		Color = Color( 180, 180, 50 ),
		Model = "models/chocolateshake01/chocolateshake01.mdl",
		Description = "Отличная замена полезной еды!.",
		Price = 230,
		Armor = 0,
		Health = 0,
		Item = "food_shake",
		Outline = false,
	},
}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
addItems["PropDealer_1"] = { -- Set the Id from ahCreateNpc prop dealer here.
	[1] = {
		Name = "Couch",
		Color = Color( 255, 255, 255 ),
		Model = "models/props_c17/FurnitureCouch002a.mdl",
		Description = "This pack include a couch.",
		Price = 450,
		Armor = 50,
		Health = 80,
		Item = "the_weed_dirt",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	},
	[2] = {
		Name = "Soil Pack",
		Color = Color( 255, 255, 255 ),
		Model = "models/props_c17/FurnitureCouch002a.mdl",
		Description = "This pack include a couch.",
		Price = 450,
		Armor = 50,
		Health = 80,
		Item = "the_weed_dirt",
		Outline = false, 
		Job = {["Medic"] = true, ["Mayor"] = true },
		Ulx = {["donator"] = true, ["ultradonator"] = true, ["ambassador"] = true, ["superadmin"] = true}
	}
}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

addItems["EntitiesDealer_2"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Бензин",
		Color = Color( 180, 180, 50 ),
		Model = "models/props_junk/metalgascan.mdl",
		Description = "Канистра бензина.",
		Price = 450,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_fuel_petrol",
		Outline = false
	},	
	[2] = {
		Name = "Дизель",
		Color = Color( 180, 180, 50 ),
		Model = "models/props_junk/gascan001a.mdl",
		Description = "Канистра дизель.",
		Price = 500,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_fuel_diesel",
		Outline = false
	},
	[3] = {
		Name = "Автомобилшьное электро-топливо",
		Color = Color( 180, 180, 50 ),
		Model = "models/props_junk/gascan001a.mdl",
		Description = "электро-топливо.",
		Price = 300,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_fuel_electricity",
		Outline = false
	},
	[4] = {
		Name = "Покрышка",
		Color = Color( 180, 180, 50 ),
		Model = "models/props_phx/normal_tire.mdl",
		Description = "Покрышка.",
		Price = 500,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_tire",
		Outline = false
	},
	[5] = {
		Name = "Двигатель",
		Color = Color( 180, 180, 50 ),
		Model = "models/gibs/airboat_broken_engine.mdl",
		Description = "Двигатель.",
		Price = 3000,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_engine",
		Outline = false
	},
	[6] = {
		Name = "Выхлоп",
		Color = Color( 180, 180, 50 ),
		Model = "models/props_vehicles/carparts_muffler01a.mdl",
		Description = "Выхлоп.",
		Price = 1300,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_exhaust",
		Outline = false
	},
	[7] = {
		Name = "Фара",
		Color = Color( 180, 180, 50 ),
		Model = "models/maxofs2d/light_tubular.mdl",
		Description = "Фара.",
		Price = 300,
		Armor = 10,
		Health = 10,
		Item = "vc_pickup_light",
		Outline = false,
	},
	[8] = {
		Name = "Гаечный ключ для установки деталей",
		Color = Color( 50, 180, 50 ),
		Model = "models/VC-Mod/v_wrench.mdl",
		Description = "Гаечный ключ.",
		Price = 2500,
		Armor = 10,
		Health = 10,
		Item = "vc_wrench",
		Outline = false
	},
	[10] = {
		Name = "Ломик",
		Color = Color( 50, 180, 50 ),
		Model = "models/props_c17/tools_wrench01a.mdl",
		Description = "Ломик! Открывает любые замки!",
		Price = 1200,
		Armor = 0,
		Health = 0,
		Item = "lockpick",
		Outline = false
	},
}


addItems["EntitiesDealer_3"] = { -- Set the Id from ahCreateNpc prop dealer here.
	[1] = {
		Name = "Синий шлем",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_helmets/helmet_bluecamo.mdl",
		Description = "Низкий уровень защиты.",
		Price = 70000,
		Item = "cpk_helm_blue",
		Outline = false
	},
	[2] = {
		Name = "Синий кевлар",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_kevlar/kevlar_bluecamo.mdl",
		Description = "Низкий уровень защиты.",
		Price = 70000,
		Item = "cpk_kevlar_blue",
		Outline = false
	},
	[3] = {
		Name = "Зеленый шлем",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_helmets/helmet_camo.mdl",
		Description = "Средний уровень защиты.",
		Price = 80000,
		Item = "cpk_helm_green",
		Outline = false
	},
	[4] = {
		Name = "Зеленый кевлар",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_kevlar/kevlar_camo.mdl",
		Description = "Средний уровень защиты.",
		Price = 80000,
		Item = "cpk_kevlar_green",
		Outline = false
	},
	[5] = {
		Name = "Светлый шлем",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_helmets/helmet_digitalcamo.mdl",
		Description = "Высокий уровень защиты.",
		Price = 80000,
		Item = "cpk_helm_light",
		Outline = false
	},
	[6] = {
		Name = "Светлый кевлар",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_kevlar/kevlar_digitalcamo.mdl",
		Description = "Высокий уровень защиты.",
		Price = 90000,
		Item = "cpk_kevlar_light",
		Outline = false
	},
	[7] = {
		Name = "Тактический шлем",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_newhelmets/helmetnew_camo.mdl",
		Description = "Высокий уровень защиты.",
		Price = 120000,
		Item = "cpk_helm_tactical",
		Outline = false
	},
	[8] = {
		Name = "Тактический кевлар",
		Color = Color( 255, 255, 255 ),
		Model = "models/cpk_newkevlar/kevlarnew_camo.mdl",
		Description = "Высокий уровень защиты.",
		Price = 120000,
		Item = "cpk_kevlar_tactical",
		Outline = false
	},
	[9] = {
		Name = "Раздатчик патронов",
		Color = Color( 255, 255, 255 ),
		Model = "models/Items/ammocrate_smg1.mdl",
		Description = "Халявніе патрошки.",
		Price = 120000,
		Item = "sent_ammodispenser",
		Outline = false
	},

}
---------------------------------------------------------------------------------
----------------------------------------------- ---------------------------------
---------------------------------------------------------------------------------
addItems["Pizzas"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Бургер",
		Color = Color( 180, 180, 50 ),
		Model = "models/burgerplate01/burgerplate01.mdl",
		Description = "Отличная замена полезной еды, нахуй веганов!.",
		Price = 7,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true}, -- If you do not use this row, then remove it entirely from the table.
		Item = "food_burger",
		Outline = false,
	},
	[2] = {
		Name = "Бекон",
		Color = Color( 180, 180, 50 ),
		Model = "models/bacon01/bacon01.mdl",
		Description = "Отличная замена полезной еды, нахуй веганов!.",
		Price = 20,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true},
		Item = "food_burger",
		Outline = false,
	},
	[3] = {
		Name = "Яишница",
		Color = Color( 180, 180, 50 ),
		Model = "models/eggs01/eggs01.mdl",
		Description = "ЕДААААААА!.",
		Price = 11,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true},
		Item = "food_egg",
		Outline = false,
	},
	[4] = {
		Name = "Твинки",
		Color = Color( 180, 180, 50 ),
		Model = "models/twinkie01/twinkie01.mdl",
		Description = "Отличная замена полезной еды!.",
		Price = 5,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true},
		Item = "food_twinkie",
		Outline = false,
	},
	[5] = {
		Name = "Шоколадный шейк",
		Color = Color( 180, 180, 50 ),
		Model = "models/chocolateshake01/chocolateshake01.mdl",
		Description = "Отличная замена полезной еды!.",
		Price = 10,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true},
		Item = "food_shake",
		Outline = false,
	},
	[6] = {
		Name = "Пицца пеперони",
		Color = Color( 180, 180, 50 ),
		Model = "models/peppizza02/peppizza02.mdl",
		Description = "Отличная замена полезной еды!.",
		Price = 20,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true},
		Item = "food_pepperonipizza",
		Outline = false,
	},
	[7] = {
		Name = "Сырная пицца",
		Color = Color( 180, 180, 50 ),
		Model = "models/cheesepizza01/cheesepizza01.mdl",
		Description = "Отличная замена полезной еды!.",
		Price = 25,
		Armor = 0,
		Health = 0,
		Job = {["Доставщик пиццы"] = true},
		Item = "food_cheesepizza",
		Outline = false,
	},
}
---------------------------------------------------------------------------------
-------------------------------BUISNES-------------------------------------------
---------------------------------------------------------------------------------
addItems["bisnes"] = { -- Set the Id from ahCreateNpc here.
	[1] = {
		Name = "Открыть криминальный бизнес",
		Color = Color( 255, 0, 0 ),
		Model = "models/props_junk/cardboard_box003a.mdl",
		Description = "Коробку положить на стол.",
		Price = 9000,
		Armor = 0,
		Health = 0,
		Item = "sb_crime_box",
		Outline = false,
	},
	[2] = {
		Name = "Открыть легальный бизнес",
		Color = Color( 33, 255, 0 ),
		Model = "models/props_junk/cardboard_box003a.mdl",
		Description = "Коробку положить на стол..",
		Price = 9000,
		Armor = 0,
		Health = 0,
		Item = "sb_good_box",
		Outline = false,
	},
	[3] = {
		Name = "Гайды Легальный",
		Color = Color( 33, 255, 0 ),
		Model = "models/props_lab/bindergreenlabel.mdl",
		Description = "Дать книгу РАБОЧЕМУ!.",
		Price = 5000,
		Armor = 0,
		Health = 0,
		Item = "sb_good_guide",
		Outline = false,
	},
	[4] = {
		Name = "Гайд Нелегальный",
		Color = Color( 255, 0, 0 ),
		Model = "models/props_lab/bindergreenlabel.mdl",
		Description = "Дать книгу РАБОЧЕМУ!.",
		Price = 5000,
		Armor = 0,
		Health = 0,
		Item = "sb_crime_guide",
		Outline = false,
	},
	--[5] = {
	--	Name = "Рабочее место",
	--	Color = Color( 0, 255, 255 ),
	--	Model = "models/props_wasteland/controlroom_desk001b.mdl",
	--	Description = "Отличная замена полезной еды!.",
	--	Price = 20000,
	--	Armor = 0,
	--	Health = 0,
	--	Item = "sb_wk_place",
	--	Outline = false,
	--},
	[6] = {
		Name = "Рабочий",
		Color = Color( 0, 255, 255 ),
		Model = "models/props/cs_office/chair_office.mdl",
		Description = "Это ваш подопечный, он выполняет за вас вашу грязную работу!",
		Price = 10000,
		Armor = 0,
		Health = 0,
		Item = "sb_wk_seat",
		Outline = false,
	},
}


























/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
