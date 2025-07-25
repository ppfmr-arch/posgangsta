--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- I don't remember where did I get it
-- Credits to someone

local TRAIT = {}

local Approach = math.Approach
local abs = math.abs
local Clamp = math.Clamp
local RealFrameTime = RealFrameTime

function TRAIT:Init()
    self.Current = 0
end

function TRAIT:SetScroll(scrll)
	if (not self.Enabled) then self.Scroll = 0 return end

	self.Scroll = Clamp(scrll, 0, self.CanvasSize)

	self:InvalidateLayout()
end

function TRAIT:Think()
    local current = self.Current
    local target = self.Scroll

	self.Current = Approach(current, target, 10 * abs(target - current) * RealFrameTime())

    if current ~= target then
        local parent = self:GetParent()
        local func = parent.OnVScroll
        if func then
        	func(parent, self:GetOffset())
        end
    end
end

function TRAIT:GetOffset()
    if not self.Enabled then
        return 0
    end

    return self.Current * -1
end

onyx.trait.Register("smoothscroll", TRAIT)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
