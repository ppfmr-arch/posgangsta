--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

22/04/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorGray = Color(125, 125, 125)
local wimgArrow = onyx.wimg.Simple('https://i.imgur.com/KGC51Ws.png', 'smooth mips')

AccessorFunc(PANEL, 'm_CurrentOptionText', 'CurrentOptionText')
AccessorFunc(PANEL, 'm_Font', 'Font')
AccessorFunc(PANEL, 'm_colOutlineActiveColor', 'OutlineActiveColor')
AccessorFunc(PANEL, 'm_colOutlineIdleColor', 'OutlineIdleColor')
AccessorFunc(PANEL, 'm_bHideOptionIcon', 'HideOptionIcon')

function PANEL:Init()
    self:Import('click')
    self:Import('hovercolor')
    self:SetTall(onyx.ScaleTall(30))

    self:SetColorKey('backgroundColor')
    self:SetColorIdle(colorPrimary)
    self:SetColorHover(onyx.OffsetColor(self:GetColorIdle(), -5))

    self:SetFont(onyx.Font('Comfortaa@16'))

    self:SetOutlineIdleColor(colorSecondary)
    self:SetOutlineActiveColor(colorAccent)
    self:Reset()

    self.options = {}
end

function PANEL:SetOutlineIdleColor(color)
    self.m_colOutlineIdleColor = color
    self.currentOutlineColor = onyx.CopyColor(color)
end

function PANEL:Paint(w, h)
    local thickness = 1
    local currentOutlineColor = self.currentOutlineColor

    if (self.highlight) then
        currentOutlineColor = ColorAlpha(self.highlightColor, math.abs(math.sin(CurTime() * 6)) * 200 + 55)
        if (self.highlightEndTime and self.highlightEndTime <= CurTime()) then
            self:ResetHighlight()
        end
    end

    draw.RoundedBox(8, 0, 0, w, h, currentOutlineColor)
    draw.RoundedBox(8, thickness, thickness, w - thickness * 2, h - thickness * 2, self.backgroundColor)

    local x = onyx.ScaleWide(10)
    local material = self.wimage and self.wimage:GetMaterial() or self.material

    if (material and self.current > 0 and not self.m_bHideOptionIcon) then
        local size = onyx.ScaleTall(12)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(material)
        surface.DrawTexturedRect(x, h * .5 - size * .5, size, size)

        x = x + size + onyx.ScaleWide(5)
    end

    draw.SimpleText(self.m_CurrentOptionText, self.m_Font, x, h * .5, self.current > 0 and color_white or colorGray, 0, 1)

    local sz = math.floor(h * .33)
    wimgArrow:DrawRotated(w - h * .5, h * .5, sz, sz, 0, color_white)
end

function PANEL:AddOption(text, data, bSelectedDefault, icon, url)
    return self:AddOptionAdvanced({
        text = text,
        data = data,
        bSelectedDefault = bSelectedDefault,
        icon = icon
    })
end

function PANEL:AddOptionAdvanced(tblOption)
    return table.insert(self.options, tblOption)
end

function PANEL:ChooseOptionID(index, bIgnoreProcessing)
    local option = self.options[index]
    assert(option, 'trying to set invalid option (index:' .. index .. ')')

    self:SetCurrentOptionText(option.text)
    self.current = index

    if (option.iconURL) then
        self.wimage = onyx.wimg.Simple(option.iconURL, option.iconParams)
    else
        self.wimage = nil
    end

    if (not bIgnoreProcessing) then
        self:Call('OnSelect', nil, index, option.text, option.data)
    end
end

function PANEL:GetSelectedID()
    return self.current
end

function PANEL:GetOptionData(index)
    index = index or self.current

    local option = self.options[index]
    if (option) then
        return option.data
    end
end

function PANEL:GetOptionText(index)
    index = index or self.current

    local option = self.options[index]
    if (option) then
        return option.text
    end
end

function PANEL:Reset()
    self.current = -1
    self.wimage = nil
    if (onyx.lang) then
        self:SetCurrentOptionText(onyx.lang:Get('Select an option'))
    else
        self:SetCurrentOptionText('Select an option')
    end
    if (IsValid(self.dmenu)) then
        self.dmenu:Close()
    end
end

function PANEL:Clear()
    self.options = {}
    self:Reset()
end

function PANEL:GetOptions()
    return self.options
end

function PANEL:FindOptionByData(data)
    for index, option in ipairs(self.options) do
        if (option.data and option.data == data) then
            return option, index
        end
    end
end

function PANEL:DoClick()
    if (self.active) then
        return
    end

    self:ResetHighlight()

    local x, y = self:LocalToScreen(0, 0)

    local dmenu = vgui.Create('onyx.Menu')
    dmenu:SetPos(x, y + self:GetTall())
    dmenu:SetMinimumWidth(self:GetWide())
    dmenu.parent = self
    dmenu.Think = function(panel)
        local parent = panel.parent
        if (IsValid(parent)) then
            local x, y = parent:LocalToScreen(0, 0)
            local targetY = y + parent:GetTall()
            if (dmenu:GetY() ~= targetY) then
                dmenu:Close()
            end
            -- dmenu:SetPos(x, targetY)
        end
    end

    for index, option in ipairs(self.options) do
        local opt = dmenu:AddOption(option.text, function()
            self:ChooseOptionID(index)
        end)

        if (option.iconURL) then
            opt:SetIconURL(option.iconURL, option.iconParams)
        end
    end

    dmenu:Open()

    self.dmenu = dmenu
end

function PANEL:SetActive(bBool)
    self.active = bBool
    onyx.anim.Simple(self, .2, {
        currentOutlineColor = (bBool and self.m_colOutlineActiveColor or self.m_colOutlineIdleColor)
    }, 1)
end

function PANEL:Think()
    local bRealActive = IsValid(self.dmenu)
    if (bRealActive ~= self.active) then
        self:SetActive(bRealActive)
    end
end

function PANEL:OnRemove()
    if (IsValid(self.dmenu)) then
        self.dmenu:Remove()
    end
end

function PANEL:OnDisabled()
    local offset = -5
    self.onyxAnims = nil
    self:SetColorIdle(onyx.OffsetColor(colorPrimary, offset))
    self:SetColorHover(onyx.OffsetColor(self:GetColorIdle(), -5 + offset))
end

function PANEL:OnEnabled()
    local offset = 0
    self.onyxAnims = nil
    self:SetColorIdle(onyx.OffsetColor(colorPrimary, offset))
    self:SetColorHover(onyx.OffsetColor(self:GetColorIdle(), -5 + offset))
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

onyx.gui.Register('onyx.ComboBox', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .4, .65, function(self)
--     self:MakePopup()

--     local content = self:Add('Panel')
--     content:Dock(FILL)
--     content:DockMargin(5, 5, 5, 5)

--     for i = 1, 10 do
--         local btn = content:Add('onyx.ComboBox')
--         btn:Dock(TOP)
--         btn:DockMargin(0, 0 ,0 ,5)
--         -- btn:AddOption('Apple')
--         -- btn:AddOption('Banana')
--         -- btn:AddOption('Pear')
--         btn:AddOptionAdvanced({
--             text = 'Apple',
--             iconURL = 'https://i.imgur.com/pkL906D.png',
--             iconParams = 'smooth mips'
--         })
--         btn:AddOptionAdvanced({
--             text = 'Pear',
--             iconURL = 'https://i.imgur.com/Y4UKPLO.png',
--             iconParams = 'smooth mips'
--         })
--         btn:AddOptionAdvanced({
--             text = 'Banana',
--             iconURL = 'https://i.imgur.com/qQl0sr8.png',
--             iconParams = 'smooth mips'
--         })
--         btn:Highlight(Color(212, 72, 72))
--         -- btn:SetHideOptionIcon(true   )
--         -- btn.OnSelect = function(panel, index, text, data)
--         --     panel:Clear()
--         --     panel.current = 1
--         --     panel:SetDisabled(true)
--         --     panel:SetCurrentOptionText('Thank you for your feedback.')
--         -- end
--     end

-- end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
