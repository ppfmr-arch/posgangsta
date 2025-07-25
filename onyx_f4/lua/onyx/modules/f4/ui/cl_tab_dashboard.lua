--[[

Author: tochnonement
Email: tochnonement@gmail.com

25/12/2023

--]]

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorGradient = onyx.OffsetColor(colorAccent, -50)
local colorTertiary = onyx:Config('colors.tertiary')
local colorCircleGray = Color(69, 69, 69)
local colorLabel = color_white
local fontTitle = onyx.Font('Comfortaa Bold@16')

local L = function(...) return onyx.lang:Get(...) end

local PANEL = {}

local formatMoney do
    local format = {
        {'t', 10 ^ 12, 2},
        {'b', 10 ^ 9, 2},
        {'m', 10 ^ 6, 2},
        {'k', 10 ^ 3}
    }
    local amount = #format

    function formatMoney(money)
        for index = 1, amount do
            local data = format[index]
            local name = data[1]
            local value = data[2]
            local decimals = data[3] or 1
            if (money > value) then
                return DarkRP.formatMoney( math.Round(money / value, decimals) ) .. name
            end
        end

        return DarkRP.formatMoney(money)
    end
end

local function drawShadowBG(panel, w, h, color)
    -- local x, y = panel:LocalToScreen(0, 0)

    -- onyx.bshadows.BeginShadow()
        draw.RoundedBox(8, 0, 0, w, h, color)
    -- onyx.bshadows.EndShadow(1, 1, 2, nil, nil, 2)
end

function PANEL:Init()
    self.space = onyx.ScaleTall(10)
    self.padding = onyx.ScaleTall(10)
    self.smallHeaderHeight = onyx.ScaleTall(25)

    self.divStats = self:Add('Panel')
    self.divStats.PerformLayout = function(panel, w, h)
        local children = panel:GetChildren()
        local amount = #children
        local space = self.space
        local wide = (w - (space * (amount - 1))) / amount

        for index, child in ipairs(children) do
            child:SetWide(wide)
            child:Dock(LEFT)
            child:DockMargin(0, 0, space, 0)
        end
    end

    self.divBody = self:Add('Panel')

    self.divActions = self.divBody:Add('Panel')
    self.divActions.Paint = function(panel, w, h)
        drawShadowBG(panel, w, h, colorPrimary)
    end

    self.lblActions = self.divActions:Add('onyx.Label')
    self.lblActions:SetText(L('f4_actions_u'))
    self.lblActions:SetFont(fontTitle)
    self.lblActions:SetTextColor(colorLabel)
    self.lblActions:Dock(TOP)
    self.lblActions:DockMargin(0, 0, 0, onyx.ScaleTall(10))
    self.lblActions:CenterText()
    self.lblActions:SetTall(self.smallHeaderHeight)
    self.lblActions.Paint = function(panel, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, colorSecondary, true, true)
    end

    self.listActions = self.divActions:Add('onyx.ScrollPanel')
    self.listActions:DockMargin(self.padding, 0, self.padding, self.padding)
    self.listActions:Dock(FILL)

    self.divAdmins = self.divBody:Add('Panel')
    self.divAdmins:SetVisible(not onyx.f4:GetOptionValue('hide_admins'))
    self.divAdmins.Paint = function(panel, w, h)
        drawShadowBG(panel, w, h, colorPrimary)
    end

    self.lblAdmins = self.divAdmins:Add('onyx.Label')
    self.lblAdmins:SetText(L('f4_staffonline_u'))
    self.lblAdmins:SetFont(fontTitle)
    self.lblAdmins:SetTextColor(colorLabel)
    self.lblAdmins:Dock(TOP)
    self.lblAdmins:DockMargin(0, 0, 0, onyx.ScaleTall(10))
    self.lblAdmins:CenterText()
    self.lblAdmins:SetTall(self.smallHeaderHeight)
    self.lblAdmins.Paint = function(panel, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, colorSecondary, true, true)
    end

    self.listAdmins = self.divAdmins:Add('onyx.ScrollPanel')
    self.listAdmins:DockMargin(self.padding, 0, self.padding, self.padding)
    self.listAdmins:Dock(FILL)

    self:InitActions()
    self:InitStats()
    self:InitAdmins()
end

function PANEL:PerformLayout(w, h)
    local space = self.space

    self.divStats:SetTall(h * .25)
    self.divStats:Dock(TOP)
    self.divStats:DockMargin(0, 0, 0, space)

    self.divBody:Dock(FILL)

    self.divActions:Dock(FILL)

    self.divAdmins:Dock(RIGHT)
    self.divAdmins:SetWide((w - space * 1) * .33)
    self.divAdmins:DockMargin(space, 0, 0, 0)
end

function PANEL:InitActions()
    local client = LocalPlayer()
    local listActions = self.listActions
    local categories = {}

    for _, action in ipairs(onyx.f4.actions) do
        local category = action.category
        local canSee = action.canSee

        if (canSee and not canSee(client)) then
            continue
        end

        if (not categories[category]) then
            local lblTitle = listActions:Add('onyx.Label')
            lblTitle:SetText(onyx.lang:Get(category))
            lblTitle:SetTextColor(color_white)
            lblTitle:Font('Overpass SemiBold@16')
            lblTitle:Dock(TOP)
            lblTitle:DockMargin(0, 0, 0, onyx.ScaleTall(10))

            local gridPanel = listActions:Add('onyx.Grid')
            gridPanel:Dock(TOP)
            gridPanel:SetColumnCount(3)
            gridPanel:SetSpaceX(onyx.ScaleTall(5))
            gridPanel:SetSpaceY(gridPanel:GetSpaceX())
            gridPanel:DockMargin(0, 0, 0, onyx.ScaleTall(10))

            categories[category] = gridPanel
        end

        self:AddAction(categories[category], action.name, action.func)
    end
end

function PANEL:AddAction(grid, name, func)
    local client = LocalPlayer()
    local button = grid:Add('onyx.Button')
    button:SetText(onyx.lang:Get(name))
    button:SetGradientColor(colorGradient)
    button:SetMasking(true)
    button:Font('Comfortaa Bold@16')
    button:SetTall(onyx.ScaleTall(25))
    button.DoClick = function()
        if (func) then
            func(client)
        end
    end
end

function PANEL:InitAdmins()
    local padding = onyx.ScaleTall(5)
    local client = LocalPlayer()
    for _, ply in ipairs(player.GetAll()) do
        if (onyx.f4.IsAdmin(ply)) then
            local panel = self.listAdmins:Add('Panel')
            panel:Dock(TOP)
            panel:SetTall(onyx.ScaleTall(45))
            panel:DockPadding(padding, padding, padding, padding)
            panel.Paint = function(panel, w, h)
                draw.RoundedBox(8, 0, 0, w, h, colorTertiary)
            end

            local height = panel:GetTall() - padding * 2

            local avatar = panel:Add('onyx.RoundedAvatar')
            avatar:SetPlayer(ply, 64)
            avatar:SetWide(height)
            avatar:Dock(LEFT)
            avatar:DockMargin(0, 0, onyx.ScaleWide(10), 0)
            avatar.PaintOver = function(panel, w, h)
                onyx.DrawOutlinedCircle(w * .5, h * .5, h * .5, 3, color_white)
            end

            local lblName = panel:Add('onyx.Label')
            lblName:Font('Comfortaa Bold@16')
            lblName:Dock(TOP)
            lblName:SetTall(height * .5)
            lblName:SetContentAlignment(1)
            lblName:SetText(ply:Name())

            if (client == ply) then
                lblName:SetTextColor(colorAccent)
            end

            local lblRank = panel:Add('onyx.Label')
            lblRank:SetText(ply:GetUserGroup())
            lblRank:Font('Comfortaa@14')
            lblRank:Dock(TOP)
            lblRank:SetTall(height * .5)
            lblRank:SetTextColor(Color(200, 200, 200))
            lblRank:SetContentAlignment(7)
        end
    end
end

function PANEL:InitStats()
    local client = LocalPlayer()
    local players = player.GetAll()
    local playerOnline = #players
    local playerMax = game.MaxPlayers()
    local clientMoney = client:getDarkRPVar('money') or 0
    local totalMoney = 0
    local staffOnline = 0

    for _, ply in ipairs(players) do
        local money = ply:getDarkRPVar('money') or 0
        totalMoney = totalMoney + money

        if (onyx.f4.IsAdmin(ply)) then
            staffOnline = staffOnline + 1
        end
    end

    self:AddStat(L('f4_playersonline_u'), playerOnline .. ' / ' .. playerMax, (playerOnline / playerMax), Color(255, 238, 108))
    self:AddStat(L('f4_totalmoney_u'), formatMoney(totalMoney), (clientMoney / totalMoney), Color(36, 129, 50), Color(179, 255, 170))
    self:AddStat(L('f4_staffonline_u'), staffOnline, (staffOnline > 0 and 1 or 0), Color(160, 61, 231))
end

function PANEL:AddStat(name, info, fraction, color, color2)
    local padding = onyx.ScaleTall(10)
    local angle = math.Round(fraction * 360, 0, 360)
    local font0 = onyx.Font('Comfortaa@18')

    local panel = self.divStats:Add('Panel')
    panel.Paint = function(this, w, h)
        drawShadowBG(this, w, h, colorPrimary)
    end

    local lblTitle = panel:Add('onyx.Label')
    lblTitle:SetText(name)
    lblTitle:SetFont(fontTitle)
    lblTitle:CenterText()
    lblTitle:SetTextColor(colorLabel)
    lblTitle:Dock(TOP)
    lblTitle:DockMargin(0, 0, 0, padding)
    lblTitle:SizeToContentsY(10)
    lblTitle.Paint = function(panel, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, colorSecondary, true, true)
    end

    local content = panel:Add('Panel')
    content:Dock(FILL)
    content:DockMargin(padding, 0, padding, padding)
    content.Paint = function(panel, w, h)
        local size = math.min(w, h)
        local radius = math.floor(size * .5)
        local x0 = w * .5
        local y0 = h * .5
        local outlineWidth   = 5

        DisableClipping(true)
            onyx.DrawOutlinedCircle(x0 + 1, y0 + 1, radius, outlineWidth, Color(0, 0, 0, 100))
        DisableClipping(false)

        onyx.DrawOutlinedCircle(x0, y0, radius, outlineWidth, color2 or colorCircleGray)
        onyx.DrawWithPolyMask(panel.mask, function()
            onyx.DrawOutlinedCircle(x0, y0, radius, outlineWidth, color)
        end)

        draw.SimpleText(info, font0, w * .5, h * .5, color_white, 1, 1)
    end
    content.PerformLayout = function(panel, w, h)
        panel.mask = onyx.CalculateArc(w * .5, h * .5, 0, angle, h * .5 + 2, 24, true)
    end
end

onyx.gui.Register('onyx.f4.Dashboard', PANEL)

--[[------------------------------
DEBUG
--------------------------------]]
-- onyx.gui.Test('onyx.f4.Frame', .6, .65, function(panel)
--     panel:MakePopup()
--     panel:ChooseTab(1)
-- end)