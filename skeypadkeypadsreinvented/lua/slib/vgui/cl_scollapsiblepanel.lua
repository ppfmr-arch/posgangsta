local PANEL = {}

local font = slib.createFont("Roboto", 16)
local textcolor, shade_5, shade_10 = slib.getTheme("textcolor"), slib.getTheme("maincolor", 5), slib.getTheme("maincolor", 10)
local margin = slib.getTheme("margin")

function PANEL:Init()
    self.collapsed = true
    self.defaultH = slib.getScaledSize(24, "y")
    self.halfTall = slib.getScaledSize(8, "y")
    self:SetTall(self.defaultH)
    self:SetText("")

    self.button = vgui.Create("SButton", self)
    :SetTall(self.defaultH)
    :Dock(TOP)

    self.button.Paint = function(s,w,h)
        surface.SetDrawColor(shade_5)
        surface.DrawRect(0,h - 2,w,2)
    end

    self.button.DoClick = function()
        self.collapsed = !self.collapsed
        self:SizeTo(-1, self:getChildsHeight(), .3)
    end

    slib.wrapFunction(self, "Dock", nil, function() return self end, true)
    slib.wrapFunction(self, "DockMargin", nil, function() return self end, true)
    slib.wrapFunction(self, "SetZPos", nil, function() return self end, true)
    slib.wrapFunction(self, "SetTall", nil, function() return self end, true)
    slib.wrapFunction(self, "SetWide", nil, function() return self end, true)
    slib.wrapFunction(self, "SetPos", nil, function() return self end, true)
end

function PANEL:getChildsHeight()
    local height = self.defaultH

    if self.collapsed then
        for k,v in ipairs(self:GetChildren()) do
            if v == self.button or !v:IsVisible() then continue end
            local l, t, r, b = v:GetDockMargin()
            height = height + v:GetTall() + b + t
        end
    end

    return height + ((self.collapsed and height > self.defaultH) and margin or 0)
end

function PANEL:setTitle(str)
    self.title = str

    return self
end

function PANEL:ForceSize()
    self:SizeTo(-1, self:getChildsHeight(), .3)
end

function PANEL:forceCollapse()
    self:InvalidateChildren()
    self:SetTall(select(2, self:ChildrenSize()) + margin)

    return self
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(shade_10)
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(shade_5)
    surface.DrawRect(0,h - 2,w,2)

    draw.SimpleText(self.title, font, w * .5, self.defaultH * .5, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.collapsed and "-" or "+", font, w - margin - self.halfTall, self.defaultH * .5, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("SCollapsiblePanel", PANEL, "EditablePanel")

-- vk.com/urbanichka