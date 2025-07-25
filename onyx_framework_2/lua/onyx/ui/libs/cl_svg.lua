--[[

Author: tochnonement
Email: tochnonement@gmail.com

30/11/2023

--]]

local SVGTemplate = [[
<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: 0;
				overflow: hidden;
			}
		</style>
	</head>
	<body>
		%s
	</body>
</html>
]]

onyx.svg = onyx.svg or {
    declared = {},
    queue = {},
    cache = {}
}
onyx.svg = {
    declared = {},
    queue = {},
    cache = {}
}

local svg = onyx.svg

function svg.Render(w, h, path, callback)
    SVG_HTML = vgui.Create('DHTML')
    SVG_HTML:SetSize(w, h)

    SVG_HTML.OnDocumentReady = function(panel)
        panel.Loaded = true
    end

    SVG_HTML.PaintOver = function(panel)
        if (panel.Loaded) then
            panel.Loaded = false

            if (callback) then
                callback(panel:GetHTMLMaterial())
            end

            panel:Remove()
        end
    end

    SVG_HTML:SetHTML( SVGTemplate:format(path) )
end

function svg.Generate(w, h, path, callback)
    return table.insert(svg.queue, {
        w = w,
        h = h,
        path = path,
        callback = callback
    })
end

local WRAPPER_MT do
    WRAPPER_MT = {}
    WRAPPER_MT.__index = WRAPPER_MT

    AccessorFunc(WRAPPER_MT, 'm_Path', 'Path', FORCE_STRING) -- SVG
    AccessorFunc(WRAPPER_MT, 'm_iWidth', 'Width', FORCE_NUMBER)
    AccessorFunc(WRAPPER_MT, 'm_iHeight', 'Height', FORCE_NUMBER)
    AccessorFunc(WRAPPER_MT, 'm_Material', 'Material')

    WRAPPER_MT.GetWide = WRAPPER_MT.GetWidth
    WRAPPER_MT.GetTall = WRAPPER_MT.GetHeight

    function WRAPPER_MT:Generate()
        local path = self:GetPath()
        local width = self:GetWidth()
        local height = self:GetHeight()

        svg.Generate(width, height, path, function(material)
            if (self:GetColorable()) then
                self:ConvertMaterial(material)
            else
                self:SetMaterial(material)
            end
        end)
    end

    function WRAPPER_MT:GetColorable()
        return self.m_bColorable
    end

    function WRAPPER_MT:ConvertMaterial(material)
        assert(material)

        local uniqueID = self.uniqueID
        local newMaterial = CreateMaterial(uniqueID, 'UnlitGeneric', {
            ['$translucent'] = 1,
            ['$vertexalpha'] = 1,
            ['$vertexcolor'] = 1,
            ['$basetexture'] = material:GetName()
        })

        self:SetMaterial(newMaterial)
    end

    function WRAPPER_MT:MakeColorable()
        if (self.m_bColorable) then return end

        self.m_bColorable = true

        local material = self:GetMaterial()
        if (material) then
            self:ConvertMaterial(material)
        end
    end

    function WRAPPER_MT:Draw(x, y, w, h, color)
        local material = self:GetMaterial()
        if (material) then
            surface.SetDrawColor(color or color_white)
            surface.SetMaterial(material)
            surface.DrawTexturedRect(x, y, w or self:GetWidth(), h or self:GetHeight())
        end
    end
end

function svg.Create(id, w, h, colorable)
    local path = svg.declared[id]

    assert(path, 'trying to create undeclared svg (' .. tostring(id) .. ')')

    local uniqueID = id .. '_' .. w .. 'x' .. h
    local object = svg.cache[uniqueID]

    if (object) then
        if (colorable) then
            object:MakeColorable()
        end
        return object
    else
        svg.cache[uniqueID] = setmetatable({
            uniqueID = uniqueID,
            m_Path = path,
            m_iWidth = w,
            m_iHeight = h,
            m_bColorable = colorable
        }, WRAPPER_MT)

        svg.cache[uniqueID]:Generate()
    end

    return svg.cache[uniqueID]
end

function svg.Declare(id, path)
    svg.declared[id] = path
end

do
    local busy = false
    timer.Create('onyx.svg.QueueController', 0, 0, function()
        if (not IsValid(LocalPlayer())) then return end

        local queue = svg.queue
        local item = queue[1]
        if (item and not busy) then
            table.remove(queue, 1)
            busy = true

            svg.Render(item.w, item.h, item.path, function(material)
                busy = false
                item.callback(material)
            end)
        end
    end)
end