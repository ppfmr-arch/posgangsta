if SERVER then

	util.AddNetworkString("ooc_revamp")
	util.AddNetworkString("advert_revamp")
	util.AddNetworkString("ano_revamp")
	util.AddNetworkString("error_message_revamp")

	OOC_ADVERT_ANO_CONFIG = {}

	OOC_ADVERT_ANO_CONFIG.OOC = true

	OOC_ADVERT_ANO_CONFIG.ADVERT = true

	OOC_ADVERT_ANO_CONFIG.ANO = true

end

hook.Add( "PlayerSay", "OOC", function( call, text, teamchat )

	local args = string.Explode(" ", text)

	local argument = string.lower(args[1])

	if argument == "/ooc" or argument == "//" then

		if OOC_ADVERT_ANO_CONFIG.OOC == true then

			local text = table.concat(args, " ", 2, #args)

			if text != "" then

				local tablesend = {}
				tablesend.player = call
				tablesend.message = text
				net.Start("ooc_revamp")
				net.WriteTable(tablesend)
				net.Broadcast()	
				return ""

			else

				net.Start("error_message_revamp")
				net.Send(call)
				return ""

			end

		end

	end

	if argument == "/advert" or argument == "/ad" then

		if OOC_ADVERT_ANO_CONFIG.ADVERT == true then

			local text = table.concat(args, " ", 2, #args)

			if text != "" then

				local tablesend = {}
				tablesend.player = call
				tablesend.message = text
				net.Start("advert_revamp")
				net.WriteTable(tablesend)
				net.Broadcast()
				return ""

			else

				net.Start("error_message_revamp")
				net.Send(call)
				return ""

			end

		end

	end

	if argument == "/anonymous" or argument == "/ano" then

		if OOC_ADVERT_ANO_CONFIG.ANO == true then

		local text = table.concat(args, " ", 2, #args)

			if text != "" then

				net.Start("ano_revamp")
				net.WriteString(text)
				net.Broadcast()
				return ""

			else

				net.Start("error_message_revamp")
				net.Send(call)
				return ""

			end

		end

	end
		
end )

concommand.Add("enable_ooc", function(ply)
	if ply:IsSuperAdmin() then

		if OOC_ADVERT_ANO_CONFIG.OOC == false then

			OOC_ADVERT_ANO_CONFIG.OOC = true
			ply:PrintMessage(3, "OOC has been enabled")

		else

			ply:PrintMessage(3, "OOC is already enabled")

		end

	end
end)

concommand.Add("disable_ooc", function(ply)
	if ply:IsSuperAdmin() then

		if OOC_ADVERT_ANO_CONFIG.OOC == true then

			OOC_ADVERT_ANO_CONFIG.OOC = false
			ply:PrintMessage(3, "OOC has been disabled")

		else

			ply:PrintMessage(3, "OOC is already disabled")

		end

	end
end)

concommand.Add("enable_advert", function(ply)
	if ply:IsSuperAdmin() then

		if OOC_ADVERT_ANO_CONFIG.ADVERT == false then

			OOC_ADVERT_ANO_CONFIG.ADVERT = true
			ply:PrintMessage(3, "Advert has been enabled")

		else

			ply:PrintMessage(3, "Advert is already enabled")

		end

	end
end)

concommand.Add("disable_advert", function(ply)
	if ply:IsSuperAdmin() then

		if OOC_ADVERT_ANO_CONFIG.ADVERT == true then

			OOC_ADVERT_ANO_CONFIG.ADVERT = false
			ply:PrintMessage(3, "Advert has been disabled")

		else

			ply:PrintMessage(3, "Advert is already disabled")

		end

	end
end)

concommand.Add("enable_ano", function(ply)
	if ply:IsSuperAdmin() then

		if OOC_ADVERT_ANO_CONFIG.ANO == false then

			OOC_ADVERT_ANO_CONFIG.ANO = true
			ply:PrintMessage(3, "Ano has been enabled")

		else

			ply:PrintMessage(3, "OOC is already enabled")

		end

	end
end)

concommand.Add("disable_ano", function(ply)
	if ply:IsSuperAdmin() then

		if OOC_ADVERT_ANO_CONFIG.ANO == true then

			OOC_ADVERT_ANO_CONFIG.ANO = false
			ply:PrintMessage(3, "Ano has been disabled")

		else

			ply:PrintMessage(3, "Ano is already disabled")

		end

	end
end)