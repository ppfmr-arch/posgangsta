--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/06/2022

--]]

local PANEL = {}

AccessorFunc(PANEL, 'm_Material', 'Material')
AccessorFunc(PANEL, 'm_colColor', 'Color')
AccessorFunc(PANEL, 'm_iImageAngle', 'ImageAngle')
AccessorFunc(PANEL, 'm_iImageScale', 'ImageScale')
AccessorFunc(PANEL, 'm_iImageWide', 'ImageWide')
AccessorFunc(PANEL, 'm_iImageTall', 'ImageTall')

function PANEL:Init()
    self:SetImageScale(1)
    self:SetImageAngle(0)
    self:SetColor(color_white)
    self:SetURL('https://i.imgur.com/PnE3dNf.png', 'smooth mips')
end

function PANEL:SetImageSize(w, h)
    h = h or w -- square

    self:SetImageWide(w)
    self:SetImageTall(h)
end

function PANEL:SetURL(url, parameters)
    self.m_WebImage = onyx.wimg.Simple(url, parameters)
end

function PANEL:SetWebImage(id, parameters)
    self.m_WebImage = onyx.wimg.Create(id, parameters)
end

function PANEL:SetSVG(id, w, h, colorable)
    self.m_SVG = onyx.svg.Create(id, w, (h or w), colorable)
end

function PANEL:SetImage(path, params)
    self:SetMaterial(Material(path, params))
end

function PANEL:GetWebImage()
    return self.m_WebImage
end

function PANEL:GetSVG()
    return self.m_SVG
end

function PANEL:Paint(w, h)
    self:Call('PaintBackground', nil, w, h)

    local webImage = self:GetWebImage()
    local material = self:GetMaterial()
    local svg = self:GetSVG()
    local color = self:GetColor()
    local scale = self:GetImageScale()
    local angle = self:GetImageAngle()
    local iw, ih = self:GetImageWide() or w, self:GetImageTall() or h
    local ix, iy = w * .5, h * .5

    iw = iw * scale
    ih = ih * scale

    if svg then
    --     print(svg:GetWide(), svg:GetMaterial())
        svg:Draw(w * .5 - svg:GetWide() * .5, h * .5 - svg:GetTall() * .5, nil, nil, color)
    elseif webImage then
        webImage:DrawRotated(ix, iy, iw, ih, angle, color)
    elseif material then
        onyx.DrawMaterialRotated(material, ix, iy, iw, ih, angle, color)
    end
end

onyx.gui.Register('onyx.Image', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .65, .65, function(self)
--     local test = self:Add('onyx.Image')
--     test:SetSVG('user-outline', 128, nil, true)
--     test:SetSize(256, 256)
--     test:Center()
--     test.PaintBackground = function(panel, w, h)
--         surface.SetDrawColor(0, 0, 0)
--         surface.DrawRect(0, 0, w, h)
--     end
-- end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
