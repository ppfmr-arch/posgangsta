--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

--[[
	mLogs 2 (M4D Logs 2)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead |
	Copyright © 2018 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

local category = "stungun"

mLogs.addLogger("Player Tazed", "plytazed", category)
mLogs.addLogger("Player Un-Tazed", "plyuntazed", category)
mLogs.addLogger("Player Damage", "plydmg", category)

mLogs.addHook("PlayerTazed", category, function(victim, attacker)
	mLogs.log("plytazed", category, {
		victim = mLogs.logger.getPlayerData(victim),
		attacker = mLogs.logger.getPlayerData(attacker),
	})
end)

mLogs.addHook("PlayerPreUnTazed", category, function(victim, attacker)
	mLogs.log("plyuntazed", category, {
		victim = mLogs.logger.getPlayerData(victim),
		attacker = mLogs.logger.getPlayerData(attacker),
	})
end)

mLogs.addHook("PlayerDamagedWhileTazed", category, function(victim, dmginfo)
	local atkr = dmginfo:GetAttacker()
	local atkrobj
	if atkr:IsPlayer() then
		atkrobj = mLogs.logger.getPlayerData(atkr)
	else
		atkrobj = mLogs.logger.getEntityData(atkr)
	end

	mLogs.log("plydmg", category, {
		victim = mLogs.logger.getPlayerData(victim),
		damage = tostring(math.Round(dmginfo:GetDamage())),
		attacker = atkrobj,
	})
end)

--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600