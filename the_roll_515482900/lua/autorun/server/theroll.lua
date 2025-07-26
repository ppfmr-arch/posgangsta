concommand.Add( "rollthedice", function( ply )
	PrintMessage( HUD_PRINTTALK, ply:Nick().." крутанул "..math.random(1,100)..".")
end )

function RollCommand( pl, text, teamonly )
 if text == "/roll" then 
  pl:ConCommand( "rollthedice")
  return ""
 end
end
hook.Add( "PlayerSay", "Chat", RollCommand )