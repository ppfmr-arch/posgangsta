--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

hook.Add("PlayerTazed", "pLogs", function(victim, attacker)
	plogs.PlayerLog(victim, "Stungun", string.format("%s was tazed by %s.", victim:NameID(), attacker:NameID()), {
		["Name"]             = victim:Name(),
		["SteamID"]          = victim:SteamID(),
		["Attacker Name"]    = attacker:Name(),
		["Attacker SteamID"] = attacker:SteamID(),
	})
end)

hook.Add("PlayerPreUnTazed", "pLogs", function(victim, attacker)
	plogs.PlayerLog(victim, "Stungun", string.format("%s was un-tazed by %s.", victim:NameID(), attacker:NameID()), {
		["Name"]             = victim:Name(),
		["SteamID"]          = victim:SteamID(),
		["Attacker Name"]    = attacker:Name(),
		["Attacker SteamID"] = attacker:SteamID(),
	})
end)

hook.Add("PlayerDamagedWhileTazed", "pLogs", function(victim, dmginfo)
	if dmginfo:GetDamage() == 0 then return end

	local data = {
		["Name"]    = victim:Name(),
		["SteamID"] = victim:SteamID(),
		["Damage"]  = dmginfo:GetDamage(),
	}

	local atkrname
	if dmginfo:GetAttacker():IsPlayer() then
		atkrname = dmginfo:GetAttacker():NameID()
		data["Attacker Name"]    = dmginfo:GetAttacker():Name()
		data["Attacker SteamID"] = dmginfo:GetAttacker():SteamID()
	else
		atkrname = dmginfo:GetAttacker():GetClass()
	end

	plogs.PlayerLog(victim, "Stungun", string.format("%s took %i damage from %s while being ragdolled.", victim:NameID(), dmginfo:GetDamage(), atkrname), data)
end)
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600