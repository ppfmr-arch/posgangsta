
cam_toggle      = CreateClientConVar( "cam_toggle", KEY_T, true, true, "");

cam_noclip      = CreateClientConVar( "cam_noclip", 0, true, true, "", 0, 1 );

cam_angles      = CreateClientConVar( "cam_angles", 2, true, true, "", 1, 2 );
cam_distance    = CreateClientConVar( "cam_distance", 176, true, true, "", 0, 256 );
cam_distancemin = CreateClientConVar( "cam_distancemin", 8, true, true, "", 0, 256 );
cam_canscroll   = CreateClientConVar( "cam_canscroll", 1, true, true, "", 0, 1 );
cam_scroll      = CreateClientConVar( "cam_scroll", 8, true, true, "", 1, 16 );
cam_fov         = CreateClientConVar( "cam_fov", 75, true, true, "", 1, 100 );

cam_x           = CreateClientConVar( "cam_x", 0, true, true, "", -64, 64 );
cam_y           = CreateClientConVar( "cam_y", 0, true, true, "", -64, 64 );
cam_z           = CreateClientConVar( "cam_z", 0, true, true, "", -64, 64 );

//

hook.Add( "PlayerButtonDown", "Thirdperson", function( p, b )
    if !IsFirstTimePredicted() then
        return;
    end
    if b == cam_toggle:GetInt() then
        local i = p:GetNW2Int( "tp", 0 ) + 1;
        if i > cam_angles:GetInt() then
            i = 0;    
        end
        p:SetNW2Int( "tp", i ); 
    end
end );

hook.Add( "StartCommand", "UpdateMouse", function( p, c )
    if p:GetNW2Int( "tp", 0 ) != 0 && c:GetMouseWheel() != 0 && cam_canscroll:GetBool() then
        p:SetNW2Float( "ScrollLevel", p:GetNW2Float( "ScrollLevel", cam_distance:GetInt() ) - ( c:GetMouseWheel() * cam_scroll:GetInt() ) );
    end
end );

hook.Add( "PlayerTick", "UpdatePlayerInputs", function( p, m )
    p:SetNW2Float( "ScrollLevel", math.Clamp( p:GetNW2Float( "ScrollLevel", cam_distance:GetInt() ), cam_distancemin:GetInt(), cam_distance:GetInt() ) ); 
end );

//

hook.Add( "CalcView", "Thirdperson", function( p, pos, ang, fov )
	
    if p:GetNW2Int( "tp" ) == 0 then
        return;        
    end

    local t = { ang:Forward(), -ang:Forward() };

    local d = ( t[ p:GetNW2Int( "tp" ) ] * -p:GetNW2Float( "ScrollLevel", cam_distance:GetInt() ) ) + ( ang:Right() * cam_x:GetInt() ) + ( ang:Up() * cam_y:GetInt() ) + ( t[ p:GetNW2Int( "tp" ) ] * cam_z:GetInt() );
    local a = ( t[ p:GetNW2Int( "tp" ) ]:Angle() );

    if !cam_noclip:GetBool() then
        local tr = util.TraceLine( {
            start  = pos,
            endpos = pos + d,
            filter = p
        } );
        if tr.Hit then
            pos = tr.HitPos - d;
        end
    end

    local view = {
        origin = pos + d,
        angles = a,
        fov    = cam_fov:GetInt(),
        drawviewer = true
    };

    return view;
end );

//

hook.Add( "PopulateToolMenu", "1CameraSettings", function()

	spawnmenu.AddToolMenuOption( "Options", "Camera", "1CameraSettings", "#Third person/Free-cam", "", "", function( p )

		p:Clear();

        p:Help( "Presets:" );

        local preset = {
            ["cam_toggle"] = KEY_T,
            ["cam_angles"] = 2,
            ["cam_distance"] = 150,
            ["cam_distancemin"] = 8,
            ["cam_canscroll"] = 1,
            ["cam_scroll"] = 8,
            ["cam_fov"] = 75,
            ["cam_noclip"] = 0,
            ["cam_x"] = 0,
            ["cam_y"] = 0,
            ["cam_z"] = 0
        };

        local ps = p:ToolPresets( "Default", preset );
        
        
        p:Help( "Control binds:" );
        local b = p:KeyBinder( "Camera toggle", "cam_toggle" );

        p:Help( "Settings:" );
        local s = p:NumSlider( "Angles", "cam_angles", cam_angles:GetMin(), cam_angles:GetMax(), 0 );
        p:ControlHelp( "Number of angles the camera can cycle through before resetting back to first-person\n\n(1 = Forward, 2 = behind)" );
        local s = p:NumSlider( "Max Distance", "cam_distance", cam_distance:GetMin(), cam_distance:GetMax(), 0 );
        p:ControlHelp( "Maximum distance player can be from the player" );
        local s = p:NumSlider( "Min Distance", "cam_distancemin", cam_distancemin:GetMin(), cam_distancemin:GetMax(), 0 );
        p:ControlHelp( "Minimum distance player can be from the player" );

        local s = p:NumSlider( "Field of view", "cam_fov", cam_fov:GetMin(), cam_fov:GetMax(), 0 );
        p:ControlHelp( "Self-explanitory. This setting is independent from first-person's FOV" );

        local b = p:CheckBox( "Camera scrolling", "cam_canscroll" );
        p:ControlHelp( "If enabled, players can zoom in/out their camera using the scroll-wheel" );
        local s = p:NumSlider( "Scroll speed", "cam_scroll", cam_scroll:GetMin(), cam_scroll:GetMax(), 0 );
        p:ControlHelp( "How fast you can zoom in/out using the scroll-wheel" );

        local b = p:CheckBox( "No-clip", "cam_noclip" );
        p:ControlHelp( "If enabled, camera will not collide with the map's geometry" );


        p:Help( "Camera origin:" );
        local s = p:NumSlider( "Offset x", "cam_x", cam_x:GetMin(), cam_x:GetMax(), 0 );
        local s = p:NumSlider( "Offset y", "cam_y", cam_y:GetMin(), cam_y:GetMax(), 0 );
        local s = p:NumSlider( "Offset z", "cam_z", cam_z:GetMin(), cam_z:GetMax(), 0 );
        p:ControlHelp( "Camera's origin position relative to the player. Adjust these axes to create the camera style you want, i.e., over-the-shoulder cam" );

        p:Help( "\nThank you for installing my mod!\n" );
	end );
end );