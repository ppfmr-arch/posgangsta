--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

15/04/2022

--]]

onyx.gui = {}
onyx.gui.funcs = {}

local gui = onyx.gui

function gui.Register(name, metatable, parent)
    gui.Extend(metatable)
    vgui.Register(name, metatable, parent)
end

function gui.Extend(obj)
    for name, fn in pairs(onyx.gui.funcs) do
        obj[name] = fn
    end
end

function gui.RegisterFunc(name, fn)
    onyx.gui.funcs[name] = fn
end

-- Events

function gui.AddEvent(panel, name, fn)
    panel.onyxEvents = panel.onyxEvents or {}
    panel.onyxEvents[name] = panel.onyxEvents[name] or {
        count = 0
    }

    local storage = panel.onyxEvents[name]
    local index = storage.count + 1

    storage.count = index
    storage[index] = fn

    return index
end

function gui.RemoveEvent(panel, name, index)
    if (not panel.onyxEvents) then return false end

    local cache = panel.onyxEvents[name]
    if (not cache) then return false end

    local func = cache[index]
    if (not func) then return false end

    cache[index] = nil

    return true
end

function gui.CallEvent(panel, name, ignoreRaw, ...)
    local events = panel.onyxEvents or {}

    if not ignoreRaw and panel[name] then
        local val = panel[name](panel, ...)
        if val then
            return val
        end
    end

    local storage = events[name]
    if storage then
        for i = 1, storage.count do
            local fn = storage[i]
            if fn then
                local val = fn(panel, ...)
                if val then
                    return val
                end
            end
        end
    end
end

function gui.InjectEventHandler(panel, fnName)
    panel.onyxEventHandlers = panel.onyxEventHandlers or {}

    if panel.onyxEventHandlers[fnName] then
        return false
    end

    local oldFn = panel[fnName]

    panel[fnName] = function(self, a1, a2, a3, a4, a5, a6)
        if oldFn then
            oldFn(self, a1, a2, a3, a4, a5, a6)
        end

        -- call all events except the old function
        gui.CallEvent(self, fnName, true, a1, a2, a3, a4, a5, a6)
    end

    panel.onyxEventHandlers[fnName] = true

    return true
end

function gui.HasEventHandler(panel, fnName)
    if panel.onyxEventHandlers then
        return panel.onyxEventHandlers[fnName]
    end
end

function gui.Test(class, w, h, fn)
    if IsValid(gui.oldDebugPanel) then
        gui.oldDebugPanel:Remove()
    end

    local pnl = vgui.Create(class)
    if IsValid(pnl) then
        pnl:SetSize(ScrW() * w, ScrH() * h)
        pnl:Center()
        fn(pnl, pnl:GetWide(), pnl:GetTall())
    end
    gui.oldDebugPanel = pnl
end

gui.Register('onyx.Panel', {Init = function() end})

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
