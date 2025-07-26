--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

if SERVER then AddCSLuaFile() end
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
ahCreateNpc = {}
---------------------------------------------------------------------------------
----------------------------------Shop Id----------------------------------------
---------------------------------------------------------------------------------

--[[

	What is a shop id? well shop id determine which addItems your npc can sell.
	
	Lets say you create a new npc, 
	
	ahCreateNpc[1] = { 
	Id = "ArmorDealer_1", 
	Type = "Armor", 
	Title = "Entity Shop", 
	Model = "models/odessa.mdl",
	ThemeColor = Color( 50, 50, 180 ) 
	}
	
	And we set the Id = "" to ArmorDealer_1
	
	then you need to add it to a new row you make.
	
	So you will need to place it here in the addItems:	
	https://gyazo.com/ab5dfa8425467ef79979f8ca5ad12828
	
	Here is a zoomed out image:
	https://gyazo.com/7d60a197c12a1d04661c36ec1891d8e0
	
	You are maximum allowed to set the Id to one row, do not set to more it can interfeer.
	to create more items in the npc, you simply just add more tables in the row, fx like this:
	
	https://gyazo.com/ce81e7e112ddef7b9c8eb660b9e2d01b
	
	Overall Id is used to find the addItems table.
	
	If you got further questions about id, then you are welcome to open a ticket.
	
]]--

---------------------------------------------------------------------------------
---------------------------------Shop Type---------------------------------------
---------------------------------------------------------------------------------

--[[

	What is a shop type? well shop type determine what your npc sell.
	
	There are 5 types you can choose which are:
	
	Armor
	Health
	Weapons
	Entities
	Props
	
	Shops can not sell items from other types, which mean you can't sell health/armor under one npc.
	
	If you want a npc to sell armor then you take:
	
	Type = "Armor", 
	
	Place it inside the table
	
	ahCreateNpc[1] = {
	Id = "ArmorDealer_1", 
	Type = "Armor", -- You place type here
	Title = "Entity Shop", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 50, 50, 180 ) 
	}	
	
	if you want it to sell Entities then you just put in "Entities":
	
	ahCreateNpc[1] = {
	Id = "ArmorDealer_1", 
	Type = "Entities", -- You place type here
	Title = "Entity Shop", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 50, 50, 180 ) 
	}	

]]--

---------------------------------------------------------------------------------
----------------------------Create a dealer here---------------------------------
---------------------------------------------------------------------------------

ahCreateNpc[1] = { 
	Id = "ArmorDealer_1", -- To choose which items this npc can buy, same id as the table you want it to purchase from.
	Type = "Armor", -- What does it sell? types are written above.
	Title = "Armor Shop", -- Title of the npc?
	Model = "models/odessa.mdl", -- Model of the npc?
	ThemeColor = Color( 50, 50, 180 ) -- The theme color of the npc?
}

ahCreateNpc[2] = {
	Id = "HealthDealer_1", 
	Type = "Health", 
	Title = "Health Shop", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 255, 50, 50 ) 
}

ahCreateNpc[3] = {
	Id = "WeaponDealer_1", 
	Type = "Weapons", 
	Title = "Продавец оружия", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 50, 180, 50 )
}

ahCreateNpc[4] = {
	Id = "EntitiesDealer_1", 
	Type = "Entities", 
	Title = "Продавец еды", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 180, 180, 50 ) 
}

ahCreateNpc[5] = {
	Id = "PropDealer_1", 
	Type = "Props", 
	Title = "Prop Shop", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 255, 255, 255 )
}

ahCreateNpc[6] = {
	Id = "EntitiesDealer_2", 
	Type = "Entities", 
	Title = "Торговец Запчастей", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 180, 180, 50 ) 
}

ahCreateNpc[7] = {
	Id = "EntitiesDealer_3", 
	Type = "Entities", 
	Title = "Торговец брони", 
	Model = "models/odessa.mdl", 
	ThemeColor = Color( 180, 180, 50 ) 
}

ahCreateNpc[8] = {
	Id = "Pizzas", 
	Type = "Entities", 
	Title = "Меню доставщика пиццы", 
	Model = "models/Combine_Scanner.mdl", 
	ThemeColor = Color( 180, 180, 50 ) 
}

ahCreateNpc[9] = {
	Id = "bisnes", 
	Type = "Entities", 
	Title = "Открыть свой бизнес", 
	Model = "models/breen.mdl", 
	ThemeColor = Color( 0, 255, 255 ) 
}
ahCreateNpc[10] = {
	Id = "WeaponDealer_2", 
	Type = "Weapons", 
	Title = "Продавец оружия", 
	Model = "models/stalker.mdl", 
	ThemeColor = Color( 50, 180, 50 )
}
ahCreateNpc[11] = {
	Id = "WeaponDealer_3", 
	Type = "Weapons", 
	Title = "", 
	Model = "models/Lamarr.mdl", 
	ThemeColor = Color( 50, 180, 50 )
}
ahCreateNpc[12] = {
	Id = "WeaponDealer_4", 
	Type = "Weapons", 
	Title = "", 
	Model = "models/crow.mdl", 
	ThemeColor = Color( 50, 180, 50 )
}
---------------------------------------------------------------------------------
--------------------------Ulx restrict the dealer--------------------------------
---------------------------------------------------------------------------------

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
