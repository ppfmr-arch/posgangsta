--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

18/11/2023

--]]

do
    for thickness = 1, 6 do
        onyx.spoly.Generate('onyx_circle_outline_' .. thickness, function(w, h)
            local scaledThickness = thickness * 32

            local x = w * .5
            local y = h * .5
            local r = h * .5
            local vertices = 64

            local circleInner = onyx.CalculateCircle(x, y, r - scaledThickness, vertices)
            local circleOuter = onyx.CalculateCircle(x, y, r, vertices)

            onyx.InverseMaskFn(function()
                surface.DrawPoly(circleInner)
            end, function()
                surface.DrawPoly(circleOuter)
            end)
        end)
    end
end

do
    onyx.spoly.Generate('onyx_circle', function(w, h)
        local x0, y0 = w * .5, h * .5
        local r = h * .5
        local vertexs = 64
        local circle = onyx.CalculateCircle(x0, y0, r, vertexs)

        surface.DrawPoly(circle)
    end)
end

--[[------------------------------
Draws a smooth outline for a circle
Available thickness: [1; 6]
--------------------------------]]
function onyx.DrawOutlinedCircle(x0, y0, r, thickness, color)
    local id = 'onyx_circle_outline_' .. thickness
    local d = r * 2

    onyx.spoly.DrawRotated(id, x0, y0, d, d, 0, color)
end

--[[------------------------------
Draws a smooth circle
--------------------------------]]
function onyx.DrawCircle(x0, y0, r, color)
    local x = x0 - r
    local y = y0 - r
    local d = r * 2

    if (color) then
        surface.SetDrawColor(color)
    end
    onyx.spoly.Draw('onyx_circle', x, y, d, d)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
