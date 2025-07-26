CreateClientConVar("skeypad_hidecode", "0", true, false)

local imgui = include("s_keypad/client/imgui.lua")

local keypadData = {}

sKeypad = sKeypad or {}

local createdFrames = {}

slib.createFont("Nasalization Rg", 40, 500)
local screencode = slib.createFont("Digital dream", 50)
local screentext = slib.createFont("Digital dream", 24, 700)
local roboto21 = slib.createFont("Roboto", 21)
local roboto16 = slib.createFont("Roboto", 16)
local roboto14 = slib.createFont("Roboto", 14)
local roboto12 = slib.createFont("Roboto", 12)


local rowCount = {}
local itemCount = {}

local function addDigit(ent, digit)
	if !IsValid(ent) or ent:GetClass() ~= "s_keypad" or ent:GetSkin() ~= 0 or ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > sKeypad.config.MaxDistance or ent:GetBodygroup(2) ~= 0 then return end
	if ent.Code then
		if string.len(ent.Code) >= 4 then return end
		ent.Code = ent.Code..digit
	else
		ent.Code = digit
	end

	surface.PlaySound(sKeypad.config.KeypressSound)
end

local hovercol, transparent = Color(255, 255, 255, 40), Color(255, 255, 255, 0)
local function addButton(txt, ent, func)
	local wide, tall = 62, 51
	
    if itemCount[ent] then
        itemCount[ent] = itemCount[ent] >= 2 and -1 or itemCount[ent]
    end

    itemCount[ent] = (itemCount[ent] and itemCount[ent] + 1) or 0
    rowCount[ent] = rowCount[ent] or 0
	
	local x = wide * itemCount[ent] + (itemCount[ent] > 0 and (13 * itemCount[ent]) or 0)
	local y = tall * rowCount[ent] + (rowCount[ent] > 0 and (11 * rowCount[ent]) or 0)

	
    if imgui.xButton(x, y, wide, tall, 2, transparent, hovercol, transparent) then
        if !input.IsKeyDown(KEY_E) then return end
		if func then
			surface.PlaySound(sKeypad.config.KeypressSound)
            func(ent) return 
        else
			addDigit(ent, txt)
        end
	end

    rowCount[ent] = (itemCount[ent] >= 2 and rowCount[ent] + 1) or rowCount[ent] or 0
end

sKeypad.DrawScreen = function(ent)
    if !imgui then return end

    local ang = ent:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)

    surface.SetFont(screencode)
    local wide, tall = surface.GetTextSize("@@@@")

    local skin = ent:GetSkin()

    if imgui.Start3D2D(ent:LocalToWorld(Vector(1.164184, -3.578613, 6.865723)), ang, 0.03, 180, 170) then
        local hideCode = ConVarExists("skeypad_hidecode") and GetConVar("skeypad_hidecode"):GetBool() or false
        
        if skin == 0 then
			if ent:GetBodygroup(2) == 0 then
                draw.SimpleText("@@@@", screencode, 120, 60, slib.getTheme("maincolor", 5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(ent.Code and (hideCode and string.gsub(ent.Code, "%d", "*") or ent.Code) or "", screencode, 120 - wide * .5, 60, sKeypad.config.UI["textcolor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            elseif ent:GetBodygroup(2) == 1 then
                draw.SimpleText(slib.getLang("skeypad", sKeypad.config.Language, "awaiting"), screentext, 120, 60, slib.getTheme("orangecolor"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        elseif skin == 1 then
            if ent.Code then ent.Code = nil end
            draw.SimpleText(slib.getLang("skeypad", sKeypad.config.Language, "granted"), screentext, 120, 60, slib.getTheme("successcolor"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif skin == 2 then
            if ent.Code then ent.Code = nil end
            draw.SimpleText(slib.getLang("skeypad", sKeypad.config.Language, "denied"), screentext, 120, 60, slib.getTheme("failcolor"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
		
		imgui.End3D2D()
	end
end

sKeypad.DrawKeypad = function(ent)
    if !imgui or ent:GetSkin() ~= 0 then return end

    local ang = ent:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)

	if imgui.Start3D2D(ent:LocalToWorld(Vector(1.22, -3.177233, 1.159668)), ang, 0.03, 80, 70) then
		for i=1,9 do
			addButton(i, ent)
        end
        
        addButton("cancel", ent, function(ent) ent.Code = nil end)
        addButton(0, ent)
        addButton("enter", ent, function(ent) if !ent.Code then return end net.Start("sK:Handeler") net.WriteUInt(1, 2) net.WriteUInt(ent.Code, 14) net.SendToServer() ent.Code = nil end)

		itemCount[ent] = nil
		rowCount[ent] = nil
		
		imgui.End3D2D()
	end
end

local selectionWidth = math.floor(ScrH() * 0.04)

local matCache = {}

local function addButtonSquare(parent, ent, mat, iconsize, func, validation, toggle)
	local bttn = vgui.Create("DButton", parent)
	bttn:Dock(LEFT)
	bttn:SetWide(selectionWidth)
    bttn:SetText("")
    
    if !matCache[mat] then
        matCache[mat] = Material(mat, "noclamp smooth")
    end

	bttn.Paint = function(s,w,h)
		local size = w * iconsize

		surface.SetDrawColor(validation(ent) and slib.getTheme("successcolor") or (toggle and slib.getTheme("maincolor", 15) or slib.getTheme("failcolor")))
		surface.DrawOutlinedRect(0,0,w,h)
		
		surface.SetMaterial(matCache[mat])
		surface.SetDrawColor(slib.getTheme("whitecolor"))
		surface.DrawTexturedRect( w * .5 - (size * .5), h * .5 - (size * .5), size, size )
	end

	bttn.DoClick = function()
        func(ent)
	end
	
	return bttn
end

local function updateSetting(ent, setting)
	local newdata = keypadData[ent]

	if setting then
		newdata = keypadData[ent][setting]
	end
	
	net.Start("sK:Handeler")

	if setting then
		net.WriteUInt(3, 2)
		net.WriteEntity(ent)
		net.WriteString(setting)

		if isbool(newdata) then
			net.WriteUInt(3, 2)
			net.WriteBool(newdata)
		elseif isnumber(newdata) then
			net.WriteUInt(1, 2)
			net.WriteUInt(newdata, 14)
		elseif istable(newdata) then
			net.WriteUInt(2, 2)
			net.WriteString(util.TableToJSON(newdata))
		end
	else
		newdata = util.Compress(util.TableToJSON(newdata))

		local chunksize = #data

		net.WriteUInt(3, 2)
		net.WriteEntity(ent)
		net.WriteString("")
		net.WriteUInt(chunksize, 32)
		net.WriteData(newdata, chunksize)
	end

	net.SendToServer()
end

local function openSettings(ent)
	local settings_menu = vgui.Create("SFrame")
	:setTitle(slib.getLang("skeypad", sKeypad.config.Language, "title"))
	:SetSize(slib.getScaledSize(sKeypad.config.FrameSize.x, "x"), slib.getScaledSize(sKeypad.config.FrameSize.y, "y"))
	:addCloseButton()
	:MakePopup()
	:Center()

    local canvas = vgui.Create("SScrollPanel", settings_menu.frame)
    canvas:Dock(FILL)
    canvas:GetCanvas():DockPadding(0,slib.getTheme("margin"),0,slib.getTheme("margin"))

	local modes = vgui.Create("SListPanel", canvas)
	modes:setTitle(slib.getLang("skeypad", sKeypad.config.Language, "modes"))
	:SetTall(selectionWidth + slib.getScaledSize(25, "y"))

	local selection = vgui.Create("EditablePanel", modes.frame)
	selection:Dock(TOP)
	selection:DockPadding(0,3,0,3)
	selection:SetTall(selectionWidth)

    addButtonSquare(selection, ent, "skeypad/passcode.png", .8, function(ent) keypadData[ent].mode = 0 updateSetting(ent, "mode") end, function(ent) return keypadData[ent].mode == 0 end, true)
    addButtonSquare(selection, ent, "skeypad/fingerprint.png", .7, function(ent) keypadData[ent].mode = 1 updateSetting(ent, "mode") end, function(ent) return keypadData[ent].mode == 1 end, true)

	local upgradelist = vgui.Create("SListPanel", canvas)
	upgradelist:setTitle(slib.getLang("skeypad", sKeypad.config.Language, "upgrades"))
	:SetTall(selectionWidth + slib.getScaledSize(25, "y"))

	local selection1 = vgui.Create("EditablePanel", upgradelist.frame)
	selection1:Dock(TOP)
	selection1:DockPadding(0,3,0,3)
	selection1:SetTall(selectionWidth)
	local added = 0

	for k,v in pairs(sKeypad.config.Upgrades) do
		if !DarkRP then break end
		if v.price <= -1 then continue end
		local upgrade = addButtonSquare(selection1, ent, v.icon, .7, function(ent) net.Start("sK:Handeler") net.WriteUInt(2,2) net.WriteEntity(ent) net.WriteString(k) net.SendToServer() end, function(ent) return keypadData[ent].upgrades[k] end)
		upgrade:SetZPos(v.sortOrder)
		upgrade.PaintOver = function(s,w,h)
			if !s:IsHovered() or keypadData[ent].upgrades[k] then return end
			slib.DrawBlur(s, 2)
			draw.SimpleText(sKeypad.config.Currency..string.Comma(v.price), roboto12, w * .5, h * .5, LocalPlayer():canAfford(v.price) and slib.getTheme("successcolor") or slib.getTheme("failcolor"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		added = added + 1
	end

	if added <= 0 then upgradelist:Remove() end

	local auth_list = vgui.Create("SListPanel", canvas)
	:setTitle(slib.getLang("skeypad", sKeypad.config.Language, "auth_list"))
	:SetTall(slib.getScaledSize(180,"y"))
	:DockMargin(slib.getTheme("margin"),0,slib.getTheme("margin"),slib.getTheme("margin"))

	for k,v in pairs(player.GetAll()) do
		if v:IsBot() or v == LocalPlayer() then continue end
		local _, entry = auth_list:addEntry(v, true, slib.getLang("skeypad", sKeypad.config.Language, "players"))

		if v:GetFriendStatus() == "friend" then entry:SetZPos(-10) end
			
		entry.toggleCheck = function() return keypadData[ent]["authed"][v:SteamID()] end
		entry.DoClick = function()
			keypadData[ent]["authed"][v:SteamID()] = !keypadData[ent]["authed"][v:SteamID()]
			updateSetting(ent, "authed")
		end
	end

	if DarkRP and RPExtraTeams then
		for k,v in pairs(RPExtraTeams) do
			local _, entry = auth_list:addEntry(team.GetName(k), true, slib.getLang("skeypad", sKeypad.config.Language, "darkrp_jobs"))

			entry.toggleCheck = function() return keypadData[ent]["authed"][team.GetName(k)] end

			entry.DoClick = function()
				keypadData[ent]["authed"][team.GetName(k)] = !keypadData[ent]["authed"][team.GetName(k)]
				updateSetting(ent, "authed")
			end
		end
	end

	auth_list:addDropdown()
	:addOption(slib.getLang("skeypad", sKeypad.config.Language, "players"))
	:addOption(slib.getLang("skeypad", sKeypad.config.Language, "darkrp_jobs"))

	if BlobsPartyConfig or party or sPartySystem then
		local authedparty = vgui.Create("SStatement", canvas)
		local _, ap = authedparty:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "auth_party"), keypadData[ent].authed["party"])
			
		ap.onValueChange = function(newval)
			keypadData[ent]["authed"]["party"] = newval
			updateSetting(ent, "authed")
		end
	end

	if mg2 then
		local authedgang = vgui.Create("SStatement", canvas)
		local _, ag = authedgang:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "auth_gang"), keypadData[ent].authed["gang"])
			
		ag.onValueChange = function(newval)
			keypadData[ent]["authed"]["gang"] = newval
			updateSetting(ent, "authed")
		end
	end

	if FPP then
		local authedfpp = vgui.Create("SStatement", canvas)
		local _, aFPP = authedfpp:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "auth_fpp_buddy"), keypadData[ent].authed["fppbuddy"])
			
		aFPP.onValueChange = function(newval)
			keypadData[ent]["authed"]["fppbuddy"] = newval
			updateSetting(ent, "authed")
		end
	end

	local canAuthEdit = vgui.Create("SStatement", canvas)
	local _, cAE = canAuthEdit:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "auth_cansettings"), keypadData[ent].canauthedit)
		
	cAE.onValueChange = function(newval)
		keypadData[ent].canauthedit = newval
		updateSetting(ent, "canauthedit")
	end

	local codeentry = vgui.Create("SStatement", canvas)
	local _, ce_num = codeentry:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "access_code"), keypadData[ent].code)
	ce_num:SetMax(9999)
	ce_num:SetMin(0)

	ce_num.onValueChange = function(newval)
		keypadData[ent].code = newval
		updateSetting(ent, "code")
	end

	local timerOpen = vgui.Create("SStatement", canvas)
	local _, to_num = timerOpen:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "hold_length"), keypadData[ent].timer)
	to_num:SetMax(sKeypad.config.GrantedDelay.max)
	to_num:SetMin(sKeypad.config.GrantedDelay.min)

	to_num.onValueChange = function(newval)
		keypadData[ent].timer = newval
		updateSetting(ent, "timer")
	end

	local toggleOpen = vgui.Create("SStatement", canvas)
	local _, tO = toggleOpen:addStatement(slib.getLang("skeypad", sKeypad.config.Language, "start_faded"), keypadData[ent].toggle)


	tO.onValueChange = function(newval)
		keypadData[ent].toggle = newval
		updateSetting(ent, "toggle")
	end
end

local pressedKeys = {}

local ENUMToKey = {
	[37] = 0,
	[38] = 1,
	[39] = 2,
	[40] = 3,
	[41] = 4,
	[42] = 5,
	[43] = 6,
	[44] = 7,
	[45] = 8,
	[46] = 9
}

timer.Create("numpadKeyPressDetection", .01, 0, function()
	for i=37,46 do
		if input.IsKeyDown(i) and !pressedKeys[i] then
			pressedKeys[i] = true
		end
	end

	local enter, backspace = (input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER)), input.IsKeyDown(KEY_BACKSPACE)

	if enter or backspace then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:GetClass() == "s_keypad" and ent:GetSkin() == 0 then
			if ent.Code then
				if enter then
					net.Start("sK:Handeler") net.WriteUInt(1, 2) net.WriteUInt(ent.Code, 14) net.SendToServer() ent.Code = nil
				else
					ent.Code = nil
				end
			end
		end
	end
end)

timer.Create("numpadKeyHandeling", .05, 0, function()
	for i=37,46 do
		if pressedKeys[i] and !input.IsKeyDown(i) then
			pressedKeys[i] = nil
			local ent = LocalPlayer():GetEyeTrace().Entity
			addDigit(ent, ENUMToKey[i])
		end
	end
end)

net.Receive("sK:Handeler", function()
    local action = net.ReadUInt(2)

    if action == 1 then
        local ent = net.ReadEntity()
        local len = net.ReadUInt(32)

        if len then
            keypadData[ent] = util.JSONToTable(util.Decompress(net.ReadData(len)))
        end

    elseif action == 2 then
        local ent = net.ReadEntity()

        openSettings(ent)
	end
end)

-- vk.com/urbanichka