--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

surface.CreateFont( "ah_header_font", {
	font = "Segoe UI Semillight", 
	size = 28,
	weight = 800,
	antialias = true,
} )

surface.CreateFont( "ah_header_font2", {
	font = "Segoe UI Semillight", 
	size = 24,
	weight = 800,
	antialias = true,
} )

surface.CreateFont( "ah_close_font", {
	font = "Segoe UI Semilight", 
	size = 28,
	weight = 650,
	antialias = true,
} )

surface.CreateFont( "XanathF4_Font20", {
	font = "Lato",
	size = 20,
	weight = 500,
	antialias = true,
} )

surface.CreateFont( "XanathF4_Font32", {
	font = "Lato",
	size = 32,
	weight = 500,
	antialias = true,
} )

local blur = Material("pp/blurscreen")
local xanathborder = Material( "materials/xanathf4/Main_Box.png" )
local xanathborder2 = Material( "materials/xanathf4/main_box2.png" )
local xanathborder3 = Material( "materials/xanathf4/Line.png" )
local xanathborder4 = Material( "materials/xanathf4/buttonbackground.png" )
local xanathborder5 = Material( "materials/xanathf4/select_job_button.png" )

local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end	

local function menu()
	local entity = net.ReadEntity()
	local col = entity:GetThemeColor()
	local ply = LocalPlayer()
	local ahFrame = vgui.Create("DFrame")
	ahFrame:SetSize( 760, 660 ) 
	ahFrame:SetTitle( "" )
	ahFrame:SetVisible( true )
	ahFrame:SetDraggable( false )
	ahFrame:ShowCloseButton( false )
	ahFrame:SetDeleteOnClose( false )
	ahFrame:MakePopup()
	ahFrame:Center()
	ahFrame.Paint = function( self, w, h )		
		DrawBlur(ahFrame, 5)
		draw.RoundedBox( 0, 0, 0, 760, 660, Color( 0, 0, 0, 240 ) )	
		draw.RoundedBox( 0, 0, 0, w, h - (620), Color( 33, 33, 33, 200 ) )	
		draw.RoundedBox( 0, 0, 36, w, 4, Color(col.x,col.y,col.z) )		
		draw.SimpleText( entity:GetHeaderText(), "ah_header_font", w/2, 16, Color(col.x,col.y,col.z), 1, 1 )		
		surface.SetDrawColor(0, 0, 0)
		ahFrame:DrawOutlinedRect()							
	end	
		
	local closeButton = vgui.Create("DButton", ahFrame)
	closeButton:SetPos(ahFrame:GetWide() - (40), 0)
	closeButton:SetSize(40,32)
	closeButton:SetText("")
	closeButton:SetTextColor( Color( 255, 255, 255 ))
	closeButton.Paint = function(self,w,h)
	if ( !self:IsHovered() ) then	
		draw.RoundedBox(0,0,0,w,h, Color( 255, 140, 250, 0) )
		draw.SimpleText("X", "ah_close_font", w/2 + 1,h/2, Color( 255, 255, 255 ), 1, 1)
		else
		draw.RoundedBox(0,0,0,w,h, Color( 135, 0, 0, 255) )
		draw.SimpleText("X", "ah_close_font", w/2 + 1,h/2, Color( 255, 255, 255 ), 1, 1)
		end
	end
	closeButton.DoClick = function()	
		ahFrame:Remove()
	end	
	
	local ah = {}	
	ah.panel = vgui.Create( "DScrollPanel", ahFrame )
	ah.panel:SetSize( 760, 660 )
	ah.panel:SetPos( 0, 39 )
	ah.panel:DockMargin(0,11,0,10)
	ah.panel:Dock(FILL)

	ah.panel:GetVBar().Paint = function() return true end
	ah.panel:GetVBar().btnUp.Paint = function() return true end
	ah.panel:GetVBar().btnDown.Paint = function() return true end
	ah.panel:GetVBar().btnGrip.Paint = function() return true end
	
	ah.list = vgui.Create( "DIconLayout", ah.panel)
	ah.list:SetSize( 760, 670 )
	ah.list:SetPos( 0, 17 )
	ah.list:SetSpaceY( 12 )

	if addItems[entity:GetNetWorkId()] ~= nil then
		for k, v in pairs(addItems[entity:GetNetWorkId()]) do 
			ah[k] = ah.list:Add("DPanel")
			ah[k]:SetSize( ah.list:GetWide()-20, 95 )
			ah[k].Paint = function( self, w, h )
				surface.SetDrawColor( 255, 255, 255, 255 )	
				surface.SetMaterial( xanathborder )
				surface.DrawTexturedRect( 15, 0, w-15, h  )
				surface.SetDrawColor( 255, 255, 255, 255 )	
				surface.SetMaterial( xanathborder3 )
				surface.DrawTexturedRect( 15, 0, w-15, h  )				
				if v.Outline then if v.Job or v.Ulx then				
				surface.SetDrawColor( v.Color )
				surface.DrawOutlinedRect( 15, 0, w-15, h )
					end
				end
				surface.SetDrawColor( 255, 255, 255, 255 )	
				surface.SetMaterial( xanathborder4 )
				surface.DrawTexturedRect( 566, 14, 70, 35  )			
				draw.RoundedBox( 0, 15, 0, w, 5, v.Color )		
				draw.RoundedBox( 0, 20, 12, 75, 75, Color( 30, 30, 30 ) )
				draw.SimpleText( v.Name, "XanathF4_Font32", 115, 9, Color( 255, 255, 255 ), 0, 0 )
				draw.SimpleText( v.Description, "XanathF4_Font20", 115, 55, Color( 255, 255, 255 ), 0, 0 )		
				draw.SimpleText( "$"..string.Comma(v.Price), "XanathF4_Font20", 550, 37, Color( 255, 255, 255 ), 1, 1 )	
			end	
			ah[k].model = vgui.Create( "DModelPanel", ah[k] )
			ah[k].model:SetSize( 80, 80 )
			ah[k].model:SetPos( 15, 10 )
			ah[k].model:SetModel( v.Model )
			ah[k].model.LayoutEntity = function( self )
			local size1, size2 = self.Entity:GetRenderBounds()
			local size = (-size1+size2):Length()
			self:SetFOV(25)
			self:SetCamPos(Vector(size*2,size*1,size*1))
			self:SetLookAt((size1+size2)/2)
			end			
			ah[k].button = vgui.Create( "DButton", ah[k])
			ah[k].button:SetPos( 647, 14 )
			ah[k].button:SetSize( 101, 35 )
			ah[k].button:SetText( "" )
			ah[k].button.Paint = function( self, w, h )			
			if ( self:IsHovered() and ply:canAfford( v.Price )) then			
				surface.SetDrawColor( 255, 255, 255, 255 )	
				surface.SetMaterial( xanathborder5 )
				surface.DrawTexturedRect( 0, 0, w, h  )
				draw.SimpleText( "Purchase", "XanathF4_Font20", w / 2, h / 2 - 1, Color( 255, 255, 255 ), 1, 1 )	
			elseif ( !self:IsHovered() and ply:canAfford( v.Price ) ) then
				surface.SetDrawColor( 230, 230, 230, 255 )	
				surface.SetMaterial( xanathborder5 )
				surface.DrawTexturedRect( 0, 0, w, h  )
				draw.SimpleText( "Purchase", "XanathF4_Font20", w / 2, h / 2 - 1, Color( 255, 255, 255 ), 1, 1 )
			elseif !( ply:canAfford( v.Price ) ) then
				surface.SetDrawColor( 44, 44, 44, 255 )	
				surface.SetMaterial( xanathborder5 )
				surface.DrawTexturedRect( 0, 0, w, h  )
				draw.SimpleText( "Purchase", "XanathF4_Font20", w / 2, h / 2 - 1, Color( 50, 50, 50 ), 1, 1 )	
				end
			end
			ah[k].button.DoClick = function()
				net.Start(entity:GetTableType())
				net.WriteString(entity:GetNetWorkId())
				net.WriteInt(k,16)
				net.SendToServer()	
			end
		end
	end		
end
net.Receive("addArmor_send", function(len) menu() end)

local function adminmenu()
	local ply = LocalPlayer()		
	local ahFrame = vgui.Create("DFrame")
	ahFrame:SetSize( 280, 500 ) 
	ahFrame:SetTitle( "" )
	ahFrame:SetVisible( true )
	ahFrame:SetDraggable( false )
	ahFrame:ShowCloseButton( false )
	ahFrame:SetDeleteOnClose( false )
	ahFrame:MakePopup()
	ahFrame:Center()
	ahFrame.Paint = function( self, w, h )		
		DrawBlur(ahFrame, 5)
		draw.RoundedBox( 0, 0, 0, 560, 560, Color(0, 0, 0, 240) )		
		draw.RoundedBox( 0, 0, 34, w, 4, Color(255, 255, 255) )	
		draw.SimpleText( "ahshop spawn", "ah_header_font2", w/2, 16, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )				
		surface.SetDrawColor(0,0,0,255)
		ahFrame:DrawOutlinedRect()									
	end
	local closeButton = vgui.Create("DButton", ahFrame)
	closeButton:SetPos(ahFrame:GetWide() - (40), 0)
	closeButton:SetSize(40,32)
	closeButton:SetText("")
	closeButton:SetTextColor( Color( 255, 255, 255 ))
	closeButton.Paint = function(self,w,h)
	if ( !self:IsHovered() ) then	
		draw.SimpleText("X", "ah_header_font2", w/2 + 1,h/2, Color( 160, 20, 20 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
		draw.SimpleText("X", "ah_header_font2", w/2 + 1,h/2, Color( 180, 20, 20 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	closeButton.DoClick = function()
		ahFrame:Remove()	
	end
	local npc = {}	
	npc.panel = vgui.Create( "DScrollPanel", ahFrame )
	npc.panel:SetSize( 280, 300 )
	npc.panel:SetPos( 0, 39 )
	npc.panel:DockMargin(0,11,0,10)
	npc.panel:Dock(FILL)

	npc.panel:GetVBar().Paint = function() return true end
	npc.panel:GetVBar().btnUp.Paint = function() return true end
	npc.panel:GetVBar().btnDown.Paint = function() return true end
	npc.panel:GetVBar().btnGrip.Paint = function() return true end
	
	npc.list = vgui.Create( "DIconLayout", npc.panel)
	npc.list:SetSize( 280, 300 )
	npc.list:SetPos( 10, 10 )
	npc.list:SetSpaceY( 10 )
	
	if ahCreateNpc ~= nil then
		for k, v in pairs(ahCreateNpc) do 
			npc[k] = npc.list:Add("DPanel")
			npc[k]:SetSize( 250, 35 )
			npc[k].Paint = function( self, w, h )
				surface.SetDrawColor( 255, 255, 255, 255 )	
				surface.SetMaterial( xanathborder2 )
				surface.DrawTexturedRect( 0, 0, w, h  )		
				if ( npc[k].button:IsHovered() ) then	
				draw.RoundedBox( 0, 0, 0, w, 5, Color(240, 240, 240) )		
				else
				draw.RoundedBox( 0, 0, 0, w, 5, Color(255, 255, 255) )
				end
				draw.RoundedBox( 0, 5, 10, 55, 55, Color( 30, 30, 30 ) )
				draw.SimpleText( "Id: "..v.Id, "XanathF4_Font20", 10, 10, Color( 255, 255, 255 ) )							
			end			
			npc[k].button = vgui.Create( "DButton", npc[k])
			npc[k].button:SetPos( 177, 9 )
			npc[k].button:SetSize( 60, 23 )
			npc[k].button:SetText( "" )
			npc[k].button.Paint = function( self, w, h )			
			if ( self:IsHovered() ) then			
				draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 25, 25 ) )
				draw.SimpleText( "Spawn", "XanathF4_Font20", w / 2, h / 2 - 1, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
			else
				draw.RoundedBox( 0, 0, 0, w, h, Color( 160, 20, 20 ) )
				draw.SimpleText( "Spawn", "XanathF4_Font20", w / 2, h / 2 - 1, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			npc[k].button.DoClick = function()

				net.Start("createthenpc")
				net.WriteInt(k,16)
				net.SendToServer()
					
				end	
			end
		end
	end	
end
net.Receive("openspawnahshops", function(len) adminmenu() end)

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
