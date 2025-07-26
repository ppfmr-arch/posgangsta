local dir = "s_keypad/"

local serverfiles = {
	["sv_skeypad.lua"] = true
}

local clientfiles = {
	["imgui.lua"] = true,
	["cl_skeypad.lua"] = true
}

if SERVER then
	resource.AddFile("resource/fonts/DIGITALDREAM.ttf")
	resource.AddFile("resource/fonts/nasalization-rg.ttf")

	for k, v in pairs(serverfiles) do
		include("s_keypad/server/"..k)
	end

	include("s_keypad/integration/sv_logging.lua")

	AddCSLuaFile("s_keypad/sh_skeypad_config.lua")
	AddCSLuaFile("s_keypad/sh_skeypad.lua")
	
	AddCSLuaFile("s_keypad/languages/sh_english.lua")
	AddCSLuaFile("s_keypad/languages/sh_german.lua")
	AddCSLuaFile("s_keypad/languages/sh_italian.lua")
	AddCSLuaFile("s_keypad/languages/sh_russian.lua")
end

include("s_keypad/sh_skeypad_config.lua")
include("s_keypad/sh_skeypad.lua")

include("s_keypad/languages/sh_english.lua")
include("s_keypad/languages/sh_german.lua")
include("s_keypad/languages/sh_italian.lua")
include("s_keypad/languages/sh_russian.lua")

for k, v in pairs(clientfiles) do
	if SERVER then
		AddCSLuaFile("s_keypad/client/"..k)
	else
		include("s_keypad/client/"..k)
	end
end

-- vk.com/urbanichka