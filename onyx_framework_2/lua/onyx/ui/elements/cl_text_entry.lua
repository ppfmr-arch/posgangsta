--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorBG = colorPrimary

AccessorFunc(PANEL, 'm_PlaceholderText', 'PlaceholderText')
AccessorFunc(PANEL, 'm_colPlaceholderColor', 'PlaceholderColor')
AccessorFunc(PANEL, 'm_PlaceholderFont', 'PlaceholderFont')
AccessorFunc(PANEL, 'm_iTextSpace', 'TextSpace')

local MUTATORS = {
    'Font',
    'HistoryEnabled',
    'Multiline',
    'Numeric',
    -- 'PlaceholderColor',
    -- 'PlaceholderText',
    'TabbingDisabled',
    'TextColor',
    'UpdateOnType',
    'Value'
}

local DISPATCH = {
    'OnLoseFocus',
    'OnGetFocus',
    'AllowInput',
    'OnChange',
    'OnEnter',
    'OnKeyCode',
    'OnValueChange',
    'OnCursorEntered',
    'OnCursorExited',
}

function PANEL:Init()
    self:SetTextSpace(onyx.ScaleWide(10))
    self:SetTall(onyx.ScaleTall(30))
    self.colors = {
        outline = colorSecondary,
        accent = colorAccent
    }

    self.textEntry = self:Add('DTextEntry')
    self.textEntry:Dock(FILL)
    self.textEntry:DockPadding(0, 0, 0, 0)
    self.textEntry:DockMargin(0, 0, 0, 0)
    self.textEntry.Paint = function(panel, w, h)
        panel:DrawTextEntryText(panel:GetTextColor(), colorAccent, panel:GetTextColor())
    end

    for _, name in ipairs(MUTATORS) do
        self:CombineMutator(self.textEntry, name)
    end

    for _, name in ipairs(DISPATCH) do
        self:MakeDispatchFn(self.textEntry, name)
    end

    self:SetFont(onyx.Font('Comfortaa@16'))
    self:SetTextColor(color_white)
    self:SetPlaceholderFont(self:GetFont())
    self:SetPlaceholderColor(Color(125, 125, 125))

    self:Import('hovercolor')
    self:SetColorKey('colorBackground')
    self:SetColorIdle(colorBG)
    self:SetColorHover(onyx.OffsetColor(colorBG, -5))

    self.focusAnimFraction = 0
    self.currentOutlineColor = onyx.CopyColor( self.colors.outline )
end

function PANEL:SetDisabled(bool)
    self.textEntry:SetDisabled(bool)
    self.textEntry:SetCursor(bool and 'no' or 'beam')
    self.m_bDisabled = bool

    if (bool) then
        self:Call('OnDisabled')
    else
        self:Call('OnEnabled')
    end
end

function PANEL:GetDisabled()
    return self.m_bDisabled
end

function PANEL:OnDisabled()
    local offset = -5
    self.onyxAnims = {}
    self:SetColorIdle(onyx.OffsetColor(colorBG, offset))
    self:SetColorHover(onyx.OffsetColor(self:GetColorIdle(), -5 + offset))
end

function PANEL:OnEnabled()
    local offset = 0
    self.onyxAnims = {}
    self:SetColorIdle(onyx.OffsetColor(colorBG, offset))
    self:SetColorHover(onyx.OffsetColor(self:GetColorIdle(), -5 + offset))
end

function PANEL:PerformLayout(w, h)
    local gmodOffset = 2 -- lol, there's is slight text offset in dtextentryy (for 1920x1080)

    self:DockPadding(self.m_iTextSpace - gmodOffset, 0, self.m_iTextSpace - gmodOffset, 0)
    self:DockMargin(0, 0, 0, 0)
end

function PANEL:SetPlaceholderIcon(icon, params)
    self.placeholderWebImage = onyx.wimg.Simple(icon, params)
end

function PANEL:OnGetFocus()
    self:SetHoverBlocked(true)
    self:ResetHighlight()

    onyx.anim.Simple(self, .25, {
        focusAnimFraction = 1,
        currentOutlineColor = self.colors.accent
    }, 1, nil, nil, 'inQuad')
end

function PANEL:OnLoseFocus()
    self:SetHoverBlocked(false)
    self:OnCursorExited()

    onyx.anim.Simple(self, .25, {
        focusAnimFraction = 0,
        currentOutlineColor = self.colors.outline
    }, 1, nil, nil, 'outQuad')
end

function PANEL:Paint(w, h)
    local text = self:GetPlaceholderText()
    local color = self:GetPlaceholderColor()
    local thickness = 1
    local currentOutlineColor = self.currentOutlineColor

    if (self.highlight) then
        currentOutlineColor = ColorAlpha(self.highlightColor, math.abs(math.sin(CurTime() * 6)) * 200 + 55)
        if (self.highlightEndTime and self.highlightEndTime <= CurTime()) then
            self:ResetHighlight()
        end
    end

    draw.RoundedBox(8, 0, 0, w, h, currentOutlineColor)
    draw.RoundedBox(8, thickness, thickness, w - thickness * 2, h - thickness * 2, self.colorBackground)

    if (self:GetValue() == '' and text and text ~= '') then
        local placeholderWebImage = self.placeholderWebImage
        local x = self.m_iTextSpace

        if (placeholderWebImage) then
            local size = onyx.ScaleTall(12)

            placeholderWebImage:Draw(x, h * .5 - size * .5, size, size, colorAccent)

            x = x + size + onyx.ScaleWide(5)
        end

        draw.SimpleText(text, self:GetPlaceholderFont(), x, h * .5, color, 0, 1)
    end
end

function PANEL:Highlight(color, time)
    self.highlightColor = color
    self.highlightStartTime = CurTime()
    if (time) then
        self.highlightEndTime = CurTime() + time
    end
    self.highlight = true
end

function PANEL:ResetHighlight()
    self.highlightColor = nil
    self.highlightStartTime = nil
    self.highlightEndTime = nil
    self.highlight = nil
end

onyx.gui.Register('onyx.TextEntry', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .4, .65, function(self)
--     self:MakePopup()

--     local content = self:Add('Panel')
--     content:Dock(FILL)
--     content:DockMargin(5, 5, 5, 5)

--         local btn = content:Add('onyx.ComboBox')
--         btn:Dock(TOP)
--         btn:DockMargin(0, 0 ,0 ,5)
--     btn:Highlight(Color(212, 72, 72))

--         local btn = content:Add('onyx.TextEntry')
--         btn:Dock(TOP)
--         btn:DockMargin(0, 0 ,0 ,5)
--         btn:SetPlaceholderText('Tset')
--     btn:Highlight(Color(212, 72, 72))

-- end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
