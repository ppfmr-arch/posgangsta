--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local InteractDistance = 200

util.AddNetworkString("Armor")
util.AddNetworkString("Health")
util.AddNetworkString("Weapons")
util.AddNetworkString("Entities")
util.AddNetworkString("Props")
util.AddNetworkString("spawnahshops")
util.AddNetworkString("openspawnahshops")
util.AddNetworkString("createthenpc")

hook.Add("KeyRelease","ah_shops.NextFire",function( ply , key) -- Prevent your vgui from appearing multiply times XD

	if key == IN_USE then
		ply.AlloweNextFire_AhShop = true
	end
	
end)

net.Receive("Armor",function(len,ply, npc)
	local num = net.ReadString()	
    local val = net.ReadInt(16)	
	
	local aharmordistance 	
	
    if not ply:Alive() then 
		return 
	end		

    if not addItems[num][val] then 
		return 
	end	
	
	if (addItems[num][val].Ulx) then 
		if !addItems[num][val].Ulx[ply:GetNWString("usergroup")] then 
			DarkRP.notify( ply, 4, 5, "You are not in the correct ulx group to purchase this item!")	
			return
		end
	end
	
	if (addItems[num][val].Job) then
		if ( !addItems[num][val].Job[ team.GetName(ply:Team()) ] ) then
			DarkRP.notify( ply, 4, 5, "You are not in the correct job to purchase this item!")
			return
		end
	end

	for k,v in pairs(ents.FindByClass("ah_base")) do
		if ply:GetPos():Distance(v:GetPos()) <= InteractDistance then
			aharmordistance = true
			break
		end
	end

	if aharmordistance then
		if ( ply:Armor() >= addItems[num][val].Armor ) then
			DarkRP.notify( ply, 1, 5, "You already have "..addItems[num][val].Armor.." or more armor!" )	
	    else	
		if ( ply:canAfford( addItems[num][val].Price ) ) then
			ply:addMoney( -addItems[num][val].Price )
			ply:SetArmor( addItems[num][val].Armor or 100 )
			DarkRP.notify( ply, 4, 5, "You successfully purchased "..addItems[num][val].Armor.." armor!")	
		else	
			DarkRP.notify( ply, 1, 5, "You can not afford "..addItems[num][val].Armor.." armor!")	
			end
		end	
	end
end)

net.Receive("Health",function(len,ply)
    local num = net.ReadString(16)
    local val = net.ReadInt(16)
	
	local ahhealthdistance
	
    if not ply:Alive() then 
		return 
	end	
    if not addItems[num][val] then 
		return 
	end		

	if (addItems[num][val].Ulx) then 
		if !addItems[num][val].Ulx[ply:GetNWString("usergroup")] then 
			DarkRP.notify( ply, 4, 5, "You are not in the correct ulx group to purchase this item!")	
			return
		end
	end
	
	if (addItems[num][val].Job) then
		if ( !addItems[num][val].Job[ team.GetName(ply:Team()) ] ) then
			DarkRP.notify( ply, 4, 5, "You are not in the correct job to purchase this item!")
			return
		end
	end
	
	for k,v in pairs(ents.FindByClass("ah_base*")) do
		if ply:GetPos():Distance(v:GetPos())  <= InteractDistance then
			ahhealthdistance = true
			break
		end
	end
	
	if ahhealthdistance then
		if ( ply:Health() >= addItems[num][val].Health ) then
			DarkRP.notify( ply, 1, 5, "You already have "..addItems[num][val].Health.." or more health!" )
		else
		if ( ply:canAfford( addItems[num][val].Price ) ) then
			ply:addMoney( -addItems[num][val].Price )
			ply:SetHealth( addItems[num][val].Health or 100 )
			DarkRP.notify( ply, 4, 5, "You successfully purchased "..addItems[num][val].Health.." health!")
		else	
			DarkRP.notify( ply, 1, 5, "You can not afford "..addItems[num][val].Health.." health!")		
			end
		end		
	end
end)

net.Receive("Weapons",function(len,ply)
    local num = net.ReadString(16)
    local val = net.ReadInt(16)
	
	local ahweapondistance
	
    if not ply:Alive() then 
		return 
	end	

    if not addItems[num][val] then 
		return 
	end		

	if (addItems[num][val].Ulx) then 
		if !addItems[num][val].Ulx[ply:GetNWString("usergroup")] then 
			DarkRP.notify( ply, 4, 5, "You are not in the correct ulx group to purchase this item!")	
			return
		end
	end
	
	if (addItems[num][val].Job) then
		if ( !addItems[num][val].Job[ team.GetName(ply:Team()) ] ) then
			DarkRP.notify( ply, 4, 5, "You are not in the correct job to purchase this item!")
			return
		end
	end
	
	for k,v in pairs(ents.FindByClass("ah_base*")) do
		if ply:GetPos():Distance(v:GetPos())  <= InteractDistance then
			ahweapondistance = true
			break
		end
	end
	
	if ahweapondistance then	
		if ( ply:HasWeapon( addItems[num][val].Item ) ) then
			DarkRP.notify( ply, 1, 5, "You already have a "..addItems[num][val].Item )
		else
		if ( ply:canAfford( addItems[num][val].Price ) ) then
			ply:addMoney( -addItems[num][val].Price )
			ply:Give( addItems[num][val].Item )
			DarkRP.notify( ply, 4, 5, "You successfully purchased a "..addItems[num][val].Item )
		else
			DarkRP.notify( ply, 1, 5, "You can not afford a "..addItems[num][val].Item )
			end
		end		
	end
end)

net.Receive("Entities",function(len,ply,ent)
    local num = net.ReadString(16)
    local val = net.ReadInt(16)
	
	local ahentitiesdistance
	
    if not ply:Alive() then 
		return 
	end	
	
    if not addItems[num][val] then 
		return 
	end		
	
	if (addItems[num][val].Ulx) then 
		if !addItems[num][val].Ulx[ply:GetNWString("usergroup")] then 
			DarkRP.notify( ply, 4, 5, "You are not in the correct ulx group to purchase this item!")	
			return
		end
	end
	
	if (addItems[num][val].Job) then
		if ( !addItems[num][val].Job[ team.GetName(ply:Team()) ] ) then
			DarkRP.notify( ply, 4, 5, "You are not in the correct job to purchase this item!")
			return
		end
	end
	
	for k,v in pairs(ents.FindByClass("ah_base")) do
		if ply:GetPos():Distance(v:GetPos())  <= InteractDistance then
			ahentitiesdistance = true
			break
		end
	end
	
	if ahentitiesdistance then
		if ( ply:canAfford( addItems[num][val].Price ) ) then
			ply:addMoney( -addItems[num][val].Price )
			local ent = ents.Create( addItems[num][val].Item )
			ent:SetPos( ply:GetPos() + (ply:GetForward() * 40) )
			ent:Spawn()
			DarkRP.notify( ply, 4, 5, "You successfully purchased a "..addItems[num][val].Item )		
		else
			DarkRP.notify( ply, 1, 5, "You can not afford a "..addItems[num][val].Item )
			
		end
	end		
end)

net.Receive("Props",function(len,ply,ent)
    local num = net.ReadString(16)
    local val = net.ReadInt(16)
	
	local propdistance
	
	if not file.Exists("ahshops2/props.txt","DATA") then ply:ChatPrint("You need to set prop spawn location by typing save_ah_vector in to your console.") return end
	local ImportData = util.JSONToTable(file.Read("ahshops2/props.txt","DATA"))
	
    if not ply:Alive() then 
		return 
	end	
	if not addItems[num][val] then 
		return 
	end	
	
	if (addItems[num][val].Ulx) then 
		if !addItems[num][val].Ulx[ply:GetNWString("usergroup")] then 
			DarkRP.notify( ply, 4, 5, "You are not in the correct ulx group to purchase this item!")	
			return
		end
	end
	
	if (addItems[num][val].Job) then
		if ( !addItems[num][val].Job[ team.GetName(ply:Team()) ] ) then
			DarkRP.notify( ply, 4, 5, "You are not in the correct job to purchase this item!")
			return
		end
	end
	
	for k,v in pairs(ents.FindByClass("ah_base")) do
		if ply:GetPos():Distance(v:GetPos())  <= InteractDistance then
			propdistance = true
			break
		end
	end
	
	if propdistance then
		if ( ply:canAfford( addItems[num][val].Price ) ) then
 			ply:addMoney( -addItems[num][val].Price )
			local ent = ents.Create( "prop_physics" )
			ent:SetModel( addItems[num][val].Model )
			ent:DrawShadow( false )
			ent:SetSolid( SOLID_VPHYSICS )
			ent:SetPos( ImportData.pos )
			ent:CPPISetOwner(ply)
			ent:Spawn()
			DarkRP.notify( ply, 4, 5, "You successfully purchased a "..addItems[num][val].Name )
		else
			DarkRP.notify( ply, 1, 5, "You can not afford a "..addItems[num][val].Name )
		end
	end
end)

net.Receive("createthenpc",function(len,ply,ent)
    local val = net.ReadInt(16)
	
    if not ply:Alive() then 
		return 
	end	

    if not ahCreateNpc[val] then 
		return 
	end		

	if ( ply:IsAdmin() ) then
	
		local col = ahCreateNpc[val].ThemeColor
		local ent = ents.Create( "ah_base" )
		ent:SetPos( ply:GetPos() + (ply:GetForward() * 40) )
		ent.model = ahCreateNpc[val].Model 
		ent:SetNetWorkId( ahCreateNpc[val].Id )
		ent:SetTableType( ahCreateNpc[val].Type )
		ent:SetThemeColor( Vector(col.r,col.g,col.b) )
		ent:SetHeaderText( ahCreateNpc[val].Title )
		ent:Spawn()
		DarkRP.notify( ply, 1, 5, "You succesfully spawned a "..ahCreateNpc[val].Id  )
		ply:ChatPrint("Type save_ah_shops in to console, to save the npc permanently.")
		
		if ( ahCreateNpc[val].Type == "Props" ) then
			ply:ChatPrint("You need to set the prop spawn location for the props, by finding a spot on the map and then type save_ah_vector in to your console to set the location.")
		end
		
	end
end)

hook.Add( "PlayerSay", "spawnnpcmenu", function( ply, text, team )
	if ( string.sub( text, 1, 7 ) == "/ahmenu" ) then 
		if ply:IsAdmin() then
			net.Start("openspawnahshops")
			net.Send(ply)
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
