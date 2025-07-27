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

mLogs.addCategory(
	"Stungun",
	"stungun",
	Color(205, 205, 0),
	function()
		return istable(STUNGUN) and STUNGUN.ParalyzedTime != nil
	end
)

mLogs.addCategoryDefinitions("stungun", {
	plytazed = function(data) return mLogs.doLogReplace({"^victim", "was tazed by", "^attacker"}, data) end,
	plyuntazed = function(data) return mLogs.doLogReplace({"^victim", "was un-tazed by", "^attacker"}, data) end,
	plydmg = function(data) return mLogs.doLogReplace({"^victim", "took", "^damage", "damage from", "^attacker", "while being ragdolled"}, data) end,
})
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600