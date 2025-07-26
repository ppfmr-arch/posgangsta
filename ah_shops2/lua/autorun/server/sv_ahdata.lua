--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local function ahShops_save(ply, cmd, args)
    
	if ply:IsSuperAdmin() then
   
        local ahshops = {}

        for k,v in pairs( ents.FindByClass("ah_base") ) do
            ahshops[k] = { model = v.model, network = v:GetNetWorkId(), tabletype = v:GetTableType(), themecolor = v:GetThemeColor(), headertext = v:GetHeaderText(), pos = v:GetPos(), ang = v:GetAngles() }
        end
       
        local convert_data = util.TableToJSON( ahshops )		
        file.Write( "ahshops2/shops.txt", convert_data )
		
    end
	
end
concommand.Add("save_ah_shops", ahShops_save)

local function ahShops_vector(ply, cmd, args)
    
	if ply:IsSuperAdmin() then
   
        local ahshopsvec = {}

        ahshopsvec = { pos = ply:GetPos() }
 
       
        local convert_data = util.TableToJSON( ahshopsvec )		
        file.Write( "ahshops2/props.txt", convert_data )
		
    end
	
end
concommand.Add("save_ah_vector", ahShops_vector)

local function ahShops_respawn()
 
    if not file.IsDir( "ahshops2", "DATA" ) then
 
        file.CreateDir( "ahshops2", "DATA" )
   
    end
	
	if not file.Exists("ahshops2/shops.txt","DATA") then return end
 
    local ImportData = util.JSONToTable(file.Read("ahshops2/shops.txt","DATA"))
   
        for k, v in pairs(ImportData) do
       
        local npc = ents.Create( "ah_base" )
        npc:SetPos( v.pos )
        npc:SetAngles( v.ang )
		npc.model = v.model
		npc:SetNetWorkId(v.network)
		npc:SetTableType(v.tabletype)
		npc:SetThemeColor(v.themecolor)
		npc:SetHeaderText(v.headertext)
        npc:Spawn()
     
	end
	
end
hook.Add( "InitPostEntity", "ahShops_respawn", ahShops_respawn )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
