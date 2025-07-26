local PANEL = {}

local colorpickerMat = Material( "slib/icons/color-picker16.png", "noclamp smooth" )

local textcolor, textcolor_50, maincolor, maincolor_7, maincolor_10, accentcolor, cleanaccentcolor = slib.getTheme("textcolor"), slib.getTheme("textcolor", -50), slib.getTheme("maincolor"), slib.getTheme("maincolor", 7), slib.getTheme("maincolor", 10), slib.getTheme("accentcolor"), slib.getTheme("accentcolor")
local margin = slib.getTheme("margin")

function PANEL:Init()
    self:Dock(TOP)
    self:SetTall(slib.getScaledSize(25, "y"))
    self:DockMargin(margin, 0, margin, margin)
    self.font = slib.createFont("Roboto", 14)
	self.bg = maincolor_7
	self.elemBg = maincolor
	
	slib.wrapFunction(self, "SetZPos", nil, function() return self end, true)
	slib.wrapFunction(self, "DockMargin", nil, function() return self end, true)
end

function PANEL:Paint(w,h)
    surface.SetDrawColor(self.bg)
    surface.DrawRect(0, 0, w, h)
    draw.SimpleText(self.name, self.font, margin, h * .5, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:addStatement(name, value)
    self.name = name
	local statement = slib.getStatement(value)
	local element

	if statement == "color" then
		element = vgui.Create("SButton", self)
		element:SetWide(slib.getScaledSize(25, "y") - slib.getScaledSize(2, "x") - slib.getScaledSize(2, "x"))
		element.color = value

		element.Paint = function(s,w,h)
			surface.SetDrawColor(element.color)
			surface.DrawRect(0, 0, w, h)
			
			surface.SetDrawColor(textcolor_50)
			surface.SetMaterial(colorpickerMat)
			local sizew, sizeh = 16, 16

			surface.DrawTexturedRect( (w * .5) - (sizew * .5), (h * .5) - (sizeh * .5), sizew, sizeh )
		end


		element.OnRemove = function()
			if IsValid(element.ColorPicker) then element.ColorPicker:Remove() end
		end

		element.DoClick = function()
			if element.ColorPicker and IsValid(element.ColorPicker) then return end

			local posx, posy = self:LocalToScreen( element:GetPos() )

			element.ClosePicker = vgui.Create("SButton")
			element.ClosePicker:Dock(FILL)
			element.ClosePicker:MakePopup()
			element.ClosePicker.DoClick = function()
				if IsValid(element.ColorPicker) then element.ColorPicker:Remove() end
				if IsValid(element.ClosePicker) then element.ClosePicker:Remove() end
			end

			element.ClosePicker.Paint = function() end

			element.ColorPicker = vgui.Create("DColorMixer")
			element.ColorPicker:SetSize( slib.getScaledSize(200, "x"), slib.getScaledSize(160, "y") )
			element.ColorPicker:SetPos( posx - element.ColorPicker:GetWide(), posy )
			element.ColorPicker:SetPalette(false)
			element.ColorPicker:SetAlphaBar(false)
			element.ColorPicker:SetAlphaBar( true )
			element.ColorPicker:SetWangs(false)
			element.ColorPicker:SetColor(element.color and element.color or Color(255,0,0))
			element.ColorPicker:MakePopup()

			element.ColorPicker.Think = function()
				element.color = element.ColorPicker:GetColor()
			end

			element.ColorPicker.OnRemove = function()
				if isfunction(element.onValueChange) then
					element.onValueChange(element.color)
				end
			end
		end
	elseif statement == "bool" then
		element = vgui.Create("SButton", self)
		element:SetWide(slib.getScaledSize(25, "x") - (slib.getTheme("margin") * 2))
		element.basealpha = cleanaccentcolor.a

		element.Paint = function(s,w,h)
			surface.SetDrawColor(self.elemBg)
            surface.DrawRect(0, 0, w, h)
            
            local wantedcolor = accentcolor

			wantedcolor.a = s.enabled and element.basealpha or 0
		
            
			draw.SimpleText("✓", self.font, w * .5, h * .5, slib.lerpColor(s, wantedcolor, 3), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		element.enabled = value

		element.DoClick = function()
			element.enabled = !element.enabled
            
            if isfunction(element.onValueChange) then
				element.onValueChange(element.enabled)
            end
		end
	elseif statement == "int" then
		element = vgui.Create("DNumberWang", self)
		element:SetWide(slib.getScaledSize(50, "x"))
		element:SetDrawLanguageID(false)
		element:SetFont(self.font)
		element:SetMin(0)
		element:SetMax(2000000)

		element.Paint = function(s,w,h)
			surface.SetDrawColor(self.elemBg)
			surface.DrawRect(0, 0, w, h)

			s:DrawTextEntryText(textcolor, accentcolor, accentcolor)
		end

		element.OnValueChanged = function()
			local newvalue = element:GetValue()

			timer.Create(tostring(element), .3, 1, function()
				if isfunction(element.onValueChange) then
					element.onValueChange(newvalue)
				end
			end)
		end

		element:SetText( value )
	elseif statement == "function" or statement == "table" then
		element = vgui.Create("SButton", self)
		element:Dock(RIGHT)
		element:DockMargin(0,slib.getTheme("margin"),slib.getTheme("margin"),slib.getTheme("margin"))
		element:setTitle(statement == "function" and "Execute" or "View Table")

		element.DoClick = function()
			if statement == "function" then
				value()
			return end
			
			local display_data = vgui.Create("STableViewer")
			display_data:setTable(value)

			if isfunction(element.onElementOpen) then
				element.onElementOpen(display_data)
			end
		end
    end
    
    element:Dock(RIGHT)
    element:DockMargin(0,slib.getScaledSize(2, "x"),slib.getScaledSize(2, "x"),slib.getScaledSize(2, "x"))

	return self, element
end

vgui.Register("SStatement", PANEL, "EditablePanel")

-- vk.com/urbanichka