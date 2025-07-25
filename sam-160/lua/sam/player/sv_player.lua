if SAM_LOADED then return end

local sam = sam
local netstream = sam.netstream

do
	local connected_players = {}

	function sam.player.kick_id(id, reason)
		reason = sam.isstring(reason) and reason or sam.language.get("default_reason")
		reason = reason:sub(1, 400)
		game.KickID(id, reason)
	end

	function sam.player.is_connected(steamid)
		return connected_players[steamid] and true or false
	end

	function sam.get_connected_players()
		return connected_players
	end

	gameevent.Listen("player_connect")
	hook.Add("player_connect", "SAM.ConnectedPlayers", function(data)
		connected_players[data.networkid] = true
	end)

	gameevent.Listen("player_disconnect")
	hook.Add("player_disconnect", "SAM.ConnectedPlayers", function(data)
		connected_players[data.networkid] = nil
	end)
end

function sam.player.set_exclusive(ply, reason)
	ply.sam_exclusive_reason = reason
end

function sam.player.get_exclusive(ply, admin)
	local reason = ply.sam_exclusive_reason
	if reason then
		if ply == admin then
			return "You are " .. reason .. "!"
		else
			return ply:Name() .. " is " .. reason .. "!"
		end
	end
end

do
	local hide_weapons = function(ply, should_hide)
		for _, v in pairs(ply:GetWeapons()) do
			v:SetNoDraw(should_hide)
		end

		local physgun_beams = ents.FindByClassAndParent("physgun_beam", ply)
		if physgun_beams then
			for i = 1, #physgun_beams do
				physgun_beams[i]:SetNoDraw(should_hide)
			end
		end
	end

	local cloak = function(ply, should_cloak)
		ply:SetNoDraw(should_cloak)
		ply:DrawWorldModel(not should_cloak)
		ply:SetRenderMode(should_cloak and RENDERMODE_TRANSALPHA or RENDERMODE_NORMAL)
		ply:Fire("alpha", should_cloak and 0 or 255, 0)
		ply:sam_set_nwvar("cloaked", should_cloak)
		hide_weapons(ply, should_cloak)
	end

	function sam.player.cloak(ply)
		cloak(ply, true)
	end

	function sam.player.uncloak(ply)
		cloak(ply, false)
	end

	hook.Add("PlayerSpawn", "SAM.CloakPlayer", function(ply)
		if ply:sam_get_nwvar("cloaked") then
			cloak(ply, true)
		end
	end)

	hook.Add("PlayerSwitchWeapon", "SAM.CloakPlayer", function(ply)
		if ply:sam_get_nwvar("cloaked") then
			timer.Create("SAM.HideWeapons" .. ply:SteamID(), 0, 1, function()
				if IsValid(ply) and ply:sam_get_nwvar("cloaked") then
					hide_weapons(ply, true)
				end
			end)
		end
	end)
end

do
	local call_hook = function(ply)
		local can_spawn = hook.Call("SAM.CanPlayerSpawn", nil, ply)
		if can_spawn ~= nil then
			return can_spawn
		end
	end

	local spawn_hooks = {
		"Effect", "NPC",
		"Object", "Prop",
		"Ragdoll", "SENT",
		"SWEP", "Vehicle"
	}

	for k, v in ipairs(spawn_hooks) do
		hook.Add("PlayerSpawn" .. v, "SAM.CanPlayerSpawn", call_hook)
	end
end

do
	local persistent_data = {}

	function sam.player.set_pdata(ply, key, value)
		local ply_pdata = persistent_data[ply:AccountID()]
		if ply_pdata then
			ply_pdata[key] = value
		else
			persistent_data[ply:AccountID()] = {
				[key] = value
			}
		end
	end

	function sam.player.get_pdata(ply, key, default)
		local ply_pdata = persistent_data[ply:AccountID()]
		if ply_pdata then
			local value = ply_pdata[key]
			if value ~= nil then
				return value
			end
		end
		return default
	end
end

function sam.player.play_sound(ply, sound)
	netstream.Start(ply, "PlaySound", sound)
end

do
	hook.Add("PlayerInitialSpawn", "SAM.ReliableSendNetMessages", function(ply)
		local ply_hook = "SAM.ReliableSendNetMessages." .. ply:SteamID()
		hook.Add("SetupMove", ply_hook, function(ply_to_check, _, cmd)
			if ply_to_check == ply and not cmd:IsForced() then
				timer.Simple(0, function()
					if not IsValid(ply) then return end
					ply.sam_reliable_net_ready = true
					hook.Call("SAM.PlayerNetReady", nil, ply)
				end)
				hook.Remove("SetupMove", ply_hook)
			end
		end)
	end)
end



--[[/*d0150f579dd93edd167f5d312ec7efdd87401de3e5a8ee3e9a8b73f7fb720a9f*/]]
