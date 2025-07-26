--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local function LoadAllFiles( fdir )

	local files,dirs = file.Find( fdir.."*", "LUA" )
	
	for _,file in ipairs( files ) do
		if string.match( file, ".lua" ) then

			if SERVER then AddCSLuaFile( fdir..file ) end
			include( fdir..file )
		end	
	end
	
	for _,dir in ipairs( dirs ) do
		LoadAllFiles( fdir..dir.."/" )
	
	end
	
end

LoadAllFiles( "ahshops_config/" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
