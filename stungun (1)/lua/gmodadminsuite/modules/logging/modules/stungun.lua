--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600

if not STUNGUN then return end

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Stungun"
MODULE.Name     = "Player Tazed"
MODULE.Colour   = Color(205, 205, 0)
MODULE:Setup(function()
	MODULE:Hook("PlayerTazed", "blogs", function(ply, attacker)
		MODULE:Log("{1} was tazed by {2}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(attacker))
	end)
end)
GAS.Logging:AddModule(MODULE)


local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Stungun"
MODULE.Name     = "Player Un-Tazed"
MODULE.Colour   = Color(205, 205, 0)
MODULE:Setup(function()
	MODULE:Hook("PlayerPreUnTazed", "blogs", function(ply, attacker)
		MODULE:Log("{1} was un-tazed by {2}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(attacker))
	end)
end)
GAS.Logging:AddModule(MODULE)


local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Stungun"
MODULE.Name     = "Player Damaged"
MODULE.Colour   = Color(205, 205, 0)
MODULE:Setup(function()
	MODULE:Hook("PlayerDamagedWhileTazed", "blogs", function(ply, dmginfo)
		local atkr = dmginfo:GetAttacker()
		local atkrobj
		if atkr:IsPlayer() then
			atkrobj = bLogs:FormatPlayer(atkr)
		else
			atkrobj = bLogs:FormatEntity(atkr)
		end

		MODULE:Log(("{1} took %s damage from {2} while being ragdolled."):format(GAS.Logging:Highlight(dmginfo:GetDamage())), GAS.Logging:FormatPlayer(ply), atkrobj)
	end)
end)
GAS.Logging:AddModule(MODULE)
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#0600