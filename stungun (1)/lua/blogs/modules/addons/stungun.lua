--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

if not STUNGUN then return end

local MODULE = bLogs:Module()
MODULE.Category = "Stungun"
MODULE.Name     = "Player Tazed"
MODULE.Colour   = Color(205, 205, 0)
MODULE:Hook("PlayerTazed", "blogs", function(ply, attacker)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " was tazed by " .. bLogs:FormatPlayer(attacker) .. ".")
end)
bLogs:AddModule(MODULE)


local MODULE = bLogs:Module()
MODULE.Category = "Stungun"
MODULE.Name     = "Player Un-Tazed"
MODULE.Colour   = Color(205, 205, 0)
MODULE:Hook("PlayerPreUnTazed", "blogs", function(ply, attacker)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " was un-tazed by " .. bLogs:FormatPlayer(attacker) .. ".")
end)
bLogs:AddModule(MODULE)


local MODULE = bLogs:Module()
MODULE.Category = "Stungun"
MODULE.Name     = "Player Damaged"
MODULE.Colour   = Color(205, 205, 0)
MODULE:Hook("PlayerDamagedWhileTazed", "blogs", function(ply, dmginfo)
	local atkr = dmginfo:GetAttacker()
	local atkrstr
	if atkr:IsPlayer() then
		atkrstr = bLogs:FormatPlayer(atkr)
	else
		atkrstr = bLogs:FormatEntity(atkr)
	end

	MODULE:Log(bLogs:FormatPlayer(ply) .. " took " .. bLogs:Highlight(dmginfo:GetDamage()) .. " damage from " .. atkrstr .. " while being ragdolled.")
end)
bLogs:AddModule(MODULE)

--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600
