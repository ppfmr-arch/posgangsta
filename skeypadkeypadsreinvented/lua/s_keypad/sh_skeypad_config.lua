sKeypad = sKeypad or {}
sKeypad.config = sKeypad.config or {}

sKeypad.config.Language = "eng"

if CLIENT then
	sKeypad.config.UI = {
	["accentcolor"] = Color(201, 157, 61),
	["maincolor"] = Color(30, 30, 30),
	["textcolor"] = Color(230,230,230),
	["BGBlur"] = false
}

	sKeypad.config.FrameSize = {x = 400, y = 600}
end

sKeypad.config.AllowLockpicking = false

sKeypad.config.MaxDistance = 7500

sKeypad.config.MaxPerDoor = 2

sKeypad.config.ShockDamageRange = {min = 10, max = 15}

sKeypad.config.BypassGroups = {
	["superadmin"] = true,
	["founder"] = true,
	["root"] = true
}

sKeypad.config.Prefix = "[sKeypad] "

sKeypad.config.Currency = " т"

sKeypad.config.KeypressSound = "buttons/button15.wav"

sKeypad.config.ShockSound = "buttons/jizz.wav"

sKeypad.config.GrantedSound = "buttons/button2.wav"

sKeypad.config.DeniedSound = "buttons/button8.wav"

sKeypad.config.AlarmSound = "ambient/alarms/city_firebell_loop1.wav"

sKeypad.config.FadeMaterial = "models/props_combine/portalball001_sheet"

sKeypad.config.DoorObscuredSound = "buttons/blip1.wav"

sKeypad.config.EMPBeaconSound = "buttons/blip1.wav"

sKeypad.config.EMPExplosionSound = "weapons/stunstick/alyx_stunner1.wav"

sKeypad.config.EnablKeypadPreview = true

sKeypad.config.EnableHalos = true

sKeypad.config.HaloColor = Color(66, 179, 245)

sKeypad.config.EnableLinkBeam = true

sKeypad.config.BeamColor = Color(66, 179, 245)

sKeypad.config.BeamMat = Material("cable/cable2")

sKeypad.config.DeniedTimeout = 2.5

sKeypad.config.GrantedDelay = {min = 5, max = 15}

sKeypad.config.breakable = true

sKeypad.config.brokenTimeout = {min = 3, max = 5}

sKeypad.config.alarmTimer = 5

sKeypad.config.alarmNotify = true

sKeypad.config.empRadius = 500

sKeypad.config.Upgrades = {
	["armor"] = {
		price = 1000,
		sortOrder = 1,
		icon = "skeypad/armor.png",
		groups = {}
	},
	["emp"] = {
		price = 5000,
		sortOrder = 2,
		icon = "skeypad/emp.png",
		groups = {}
	},
	["alarm"] = {
		price = 2000,
		sortOrder = 3,
		icon = "skeypad/alarm.png",
		groups = {}
	},
	["shock"] = {
		price = 10000,
		sortOrder = 4,
		icon = "skeypad/shock.png",
		groups = {}
	}
}

sKeypad.config.WhitelistedEnts = {
	["prop_physics"] = true
}

sKeypad.config.keypads = {
	["Взломщик кейпадов"] = {
		classname = "weapon_keypadcracker_01",
		cracktime = 15,
		cracksound = Sound("buttons/blip2.wav"),
		maxdistance = 40,
		fov = 54,
		v_mdl = "models/weapons/v_c4.mdl",
		w_mdl = "models/weapons/w_c4.mdl"
	},
	["Pro взломщик кейпадов"] = {
		classname = "weapon_keypadcracker_02",
		cracktime = 8,
		cracksound = Sound("buttons/blip2.wav"),
		maxdistance = 40,
		fov = 54,
		v_mdl = "models/weapons/v_c4.mdl",
		w_mdl = "models/weapons/w_c4.mdl"
	}
}

-- vk.com/urbanichka