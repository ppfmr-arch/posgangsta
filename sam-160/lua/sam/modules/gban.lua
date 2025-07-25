GBan = GBan or {}
GBan.Config = GBan.Config or {}

GBan.Config.banned_pos = Vector(-1469, 903, 128) -- координаты изменять тут
GBan.Config.banned_model = 'models/player/charple.mdl'
GBan.Config.banned_maxspeed = 180
GBan.Config.max_seconds = 10000000000000000000

local META = FindMetaTable( 'Player' )
function META:IsGBan()

	return self:GetNWBool( 'GBan' )

end

if SERVER then

	util.AddNetworkString( 'gban_send_ply' )

	sql.Query( 'CREATE TABLE IF NOT EXISTS gban( SteamID TEXT PRIMARY KEY, Time NUMBER, Date NUMBER, Reason TEXT, Judge TEXT )' )

	function GBan.GiveBanPlayer( ePly, eAdmin, sReason, nSeconds )

		if not IsValid( ePly ) or not ePly:IsPlayer() then print( '[GBan] GiveBanPlayer ERROR #01' ) return end

		local is_gban = ePly:IsGBan()
		if is_gban then print( '[GBan] GiveBanPlayer ERROR #02' ) return end

		if not sReason or not isstring( sReason ) then print( '[GBan] GiveBanPlayer WARNING #01' ) sReason = 'Причина не указана' end
		if not nSeconds or not isnumber( nSeconds ) then print( '[GBan] GiveBanPlayer WARNING #02' ) nSeconds = 60 end
		if ( nSeconds > GBan.Config.max_seconds ) then print( '[GBan] GiveBanPlayer WARNING #03' ) nSeconds = GBan.Config.max_seconds end
		if ( nSeconds <= 0 ) then print( '[GBan] GiveBanPlayer WARNING #04' ) nSeconds = 1 end
		nSeconds = math.floor( nSeconds )
		-- Action

		ePly:changeTeam( TEAM_BANNED, true )
		ePly:SetNWBool( 'GBan', true )
		ePly:SetNWInt( 'GBanTime', nSeconds )
		if ePly:InVehicle() then ply:ExitVehicle() end
		ePly:Spawn()
		ePly:StripWeapons()
		ePly:StripAmmo()
		local nick_admin = eAdmin and eAdmin:Nick() or 'CONSOLE'
		ePly:ChatPrint( 'Администратор '..nick_admin..' выдал Вам бан по причине: '..sReason )

		timer.Create( 'GBanPlayer'..ePly:SteamID(), nSeconds, 1, function() GBan.RemoveBanPlayerOffline( ePly:SteamID() ) end )

		net.Start( 'gban_send_ply' )
			net.WriteBool( true )
			net.WriteUInt( nSeconds, 16 )
		net.Send( ePly )

		local values = Format( '(%s, %i, %i, %s, %s)', sql.SQLStr( ePly:SteamID() ), nSeconds, os.time(), sql.SQLStr( sReason ), sql.SQLStr( nick_admin ) )
		print( values )
		sql.Query( 'INSERT INTO gban( SteamID, Time, Date, Reason, Judge ) VALUES '..values )

		if eAdmin then eAdmin:ChatPrint( 'Вы выдали бан игроку '..ePly:Nick()..' по причине: '..sReason..' на '..nSeconds..' секунд' ) end
		
		print( '[GBan] Player '..ePly:SteamID()..' has banned on '..nSeconds..' sec!' )

	end

	function GBan.GiveBanPlayerOffline( sSteamID, eAdmin, nSeconds, sReason )

		if not sSteamID then print( '[GBan] GiveBanPlayerOffline ERROR #03' ) return end

		local ply = player.GetBySteamID( sSteamID )
		if ply and IsValid( ply ) then GBan.GiveBanPlayer( ply, eAdmin, sReason, nSeconds ) return end

		if ( nSeconds > GBan.Config.max_seconds ) then print( '[GBan] GiveBanPlayerOffline WARNING #03' ) nSeconds = GBan.Config.max_seconds end
		if ( nSecond <= 0 ) then print( '[GBan] GiveBanPlayerOffline WARNING #04' ) nSeconds = 1 end
		nSeconds = math.floor( nSeconds )
		
		local judge = eAdmin and eAdmin:Nick() or 'CONSOLE'
		local values = Format( '(%s, %i, %i, %s, %s)', sql.SQLStr( sSteamID ), nSeconds, os.time(), sql.SQLStr( sReason ), sql.SQLStr( judge ) )
		sql.Query( 'INSERT INTO gban( SteamID, Time, Date, Reason, Judge ) VALUES '..values )

		if eAdmin then eAdmin:ChatPrint( 'Вы выдали бан игроку '..sSteamID ) end

		print( '[GBan] Player '..sSteamID..' has banned on '..nSeconds..' sec!' )

	end

	function GBan.RemoveBanPlayer( ePly, eAdmin )

		local is_gban = ePly:IsGBan()
		if not is_gban then print( '[GBan] RemoveBanPlayer ERROR #04' ) return end

		ePly:SetNWBool( 'GBan', false )
		ePly:SetNWInt( 'GBanTime', 0 )
		ePly:changeTeam( TEAM_CITIZEN, true )
		ePly:Kill()

		net.Start( 'gban_send_ply' )
			net.WriteBool( false )
			net.WriteUInt( 0, 16 )
		net.Send( ePly )

		if timer.Exists( 'GBanPlayer'..ePly:SteamID() ) then timer.Remove( 'GBanPlayer'..ePly:SteamID() ) end

		sql.Query( 'DELETE FROM gban WHERE SteamID = '..sql.SQLStr( ePly:SteamID() ) )

		if eAdmin then 
		
			ePly:ChatPrint( 'Вам снял бан администратор '..eAdmin:Nick() ) 
			eAdmin:ChatPrint( 'Вы сняли бан игроку '..ePly:Nick() )

		end

		print( '[GBan] Player '..ePly:SteamID()..' has removed gban!' )

	end

	function GBan.RemoveBanPlayerOffline( sSteamID, eAdmin )

		if not sSteamID then print( '[GBan] ERROR #03' ) return end

		local ply = player.GetBySteamID( sSteamID )
		if ply and IsValid( ply ) then GBan.RemoveBanPlayer( ply, eAdmin ) return end

		sql.Query( 'DELETE FROM gban WHERE SteamID = '..sql.SQLStr( sSteamID ) )

		print( '[GBan] Player '..sSteamID..' has removed gban!' )

	end

	hook.Add( 'PlayerInitialSpawn', 'GBan.JailerTheFirstSpawn', function( ePly )

		timer.Simple( 2, function() 

			local steamid = sql.SQLStr( ePly:SteamID() )
			local time = sql.QueryValue( 'SELECT Time FROM gban WHERE SteamID='..steamid )
			if not time then return end
		
			time = tonumber( time ) -- only seconds!
			local date = sql.QueryValue( 'SELECT Date FROM gban WHERE SteamID='..steamid  )

			local finish_time = time + tonumber( date )
			local current_time = os.time()

			if ( finish_time <= current_time ) then sql.Query( 'DELETE FROM gban WHERE SteamID = '..steamid ) ePly:ChatPrint( 'Срок вашего бана закончился!' ) return end

			ePly:changeTeam( TEAM_BANNED, true )
			ePly:SetNWBool( 'GBan', true )
			ePly:SetNWInt( 'GBanTime', time )
			ePly:Spawn()

			net.Start( 'gban_send_ply' )
				net.WriteBool( true )
				net.WriteUInt( time, 16 )
			net.Send( ePly )

			timer.Create( 'GBanPlayer'..ePly:SteamID(), time, 1, function() GBan.RemoveBanPlayerOffline( ePly:SteamID() ) end )

		end )

	end )

	hook.Add( 'PlayerSpawn', 'GBan.JailerSpawn', function( ePly )

		if not ePly:IsGBan() then return end

		timer.Simple( 0.1, function() 

			ePly:SetPos( GBan.Config.banned_pos )
			ePly:SetModel( GBan.Config.banned_model )
			ePly:SetCrouchedWalkSpeed( GBan.Config.banned_maxspeed )
			ePly:SetRunSpeed( GBan.Config.banned_maxspeed )
			ePly:SetWalkSpeed( GBan.Config.banned_maxspeed )
			ePly:StripWeapons()

		end )

	end )

	hook.Add( 'PlayerDisconnected', 'GBan.UpdateTimeForJailer', function( ePly )

		if not ePly:IsGBan() then return end

		local steamid, time = sql.SQLStr( ePly:SteamID() ), math.floor( timer.TimeLeft( 'GBanPlayer'..ePly:SteamID() ) )
		sql.Query( 'UPDATE gban SET Time='.. time ..' WHERE SteamID='.. steamid )

		timer.Remove( 'GBanPlayer'..ePly:SteamID() )

	end)

	-- Restrict

	hook.Add( 'CanPlayerSuicide', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end )

	hook.Add( 'PlayerLoadout', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end )

	hook.Add( 'PlayerSpawnObject', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

	hook.Add( 'PlayerSpawnSENT', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

	hook.Add( 'PlayerSpawnNPC', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

	hook.Add( 'PlayerSpawnSWEP', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

	hook.Add( 'PlayerSpawnVehicle', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

	hook.Add( 'PlayerGiveSWEP', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

	hook.Add( 'PlayerCanPickupWeapon', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)

    hook.Add( 'PlayerCanPickupItem', 'GBan.RestrictHook', function( ePly )
        
		if ePly:IsGBan() then return false end 

    end )

    hook.Add( 'playerCanChangeTeam', "GhostBan_CantChangeJob",function( ePly )
        
		if ePly:IsGBan() then return false end 

    end)

--	hook.Add( 'PlayerCanJoinTeam', 'GBan.RestrictHook', function( ePly )
--
--		if ePly:IsGBan() then return false end 
--
--	end )

	hook.Add( 'CanPlayerEnterVehicle', 'GBan.RestrictHook', function( ePly )

		if ePly:IsGBan() then return false end

	end )

	hook.Add( 'PlayerNoClip', 'GBan.RestrictHook', function( ePly ) 
		
		if ePly:IsGBan() then return false end 
		
	end)



elseif CLIENT then

	local w = ScrW()
	local h = ScrH()

	surface.CreateFont( 'TheShitFont', {

		font = "Trebuchet24",
		size = ( h + w ) * .011,
		weight = 300, 
		blursize = 0, 
		scanlines = 0, 
		antialias = false, 
		underline = false, 
		italic = false, 
		strikeout = false, 
		symbol = false, 
		rotary = false, 
		shadow = true, 
		additive = false, 
		outline = false,

	} )

	local COLOR_WHITE = Color( 255, 255, 255 )
	local COLOR_BLACK = Color( 0, 0, 0 )

	net.Receive( 'gban_send_ply',function()

		to_ban = net.ReadBool()
		time = net.ReadUInt( 16 )

		if not to_ban then hook.Remove( 'HUDPaint', 'GBan.DrawInfoPanel' ) return end

		timer.Create( 'GBanTime', time, 1, function() end )

		hook.Add( 'HUDPaint', 'GBan.DrawInfoPanel', function()

			if not LocalPlayer():IsGBan() then return end
			local time = timer.Exists( 'GBanTime' ) and math.floor( timer.TimeLeft( 'GBanTime' ) ) or 0
	        draw.SimpleTextOutlined( 'До снятия бана осталось '.. time ..' секунд', 'TheShitFont', w / 2, 0, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, COLOR_BLACK )

		end)

	end)

end

if SAM_LOADED then return end
local sam, cmd, lang = sam, sam.command, sam.language
local cat = 'gBan'

cmd.set_category( cat )

cmd.new( 'gban' )

    :Help( 'Банит игрока' )

	:SetPermission( 'gban', 'admin' )

	:AddArg( 'player' )
	:AddArg( 'number', { hint = 'Секунды', min = 1, max = GBan.Config.max_seconds, round = true, optional = true, default = 250 } )
    :AddArg( 'text', { hint = 'Причина' } )

	:OnExecute( function( eAdmin, tTargets, nSeconds, sReason )

		if #tTargets > 1 then return end

		for i=1, #tTargets do

			local ply = tTargets[i]

			GBan.GiveBanPlayer( ply, eAdmin, sReason, nSeconds )

		end

	end )

:End()

cmd.new( 'ungban' )

    :Help( 'Убирает у игрока gban' )

	:SetPermission( 'ungban', 'admin' )

	:AddArg( 'player' )

	:OnExecute( function( eAdmin, target )

		if #target > 1 then return end

		for i=1, #target do

			local ply = target[i]

			GBan.RemoveBanPlayer( ply, eAdmin )

		end

	end )

:End()