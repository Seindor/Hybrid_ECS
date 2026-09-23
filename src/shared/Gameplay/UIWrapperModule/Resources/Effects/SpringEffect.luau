--!strict
local Animator = require("../../Components/Animator")

local Helpers = require("../../Components/Helpers")
local IUIWrapper = require("../../Data/IUIWrapper")
local UIWrapperTypes = require("../../Data/Types")

local SpringEffect = {}
SpringEffect.__index = SpringEffect

export type SpringEffect = typeof(setmetatable({} :: { wrapper: IUIWrapper.IEffectHost }, SpringEffect))

function SpringEffect.new(wrapper: IUIWrapper.IEffectHost): SpringEffect
	return setmetatable({ wrapper = wrapper }, SpringEffect)
end

--[[
	Затухающая пружина от startScale к targetScale.
	amplitude: 1 = обычная раскачка, >1 - сильнее.
]]
function SpringEffect.Emit(self: SpringEffect, params: UIWrapperTypes.SpringEffectParams?)
	local uiScale = Helpers.FindUIScale(self.wrapper.instance, "SpringEffect")
	if not uiScale then return end

	local duration = if params and params.duration then params.duration else 0.4
	local damping = if params and params.damping then params.damping else 7
	local frequency = if params and params.frequency then params.frequency else 12
	local amplitude = if params and params.amplitude then params.amplitude else 1

	local start = if params and params.startScale then params.startScale else uiScale.Scale
	local target = if params and params.targetScale then params.targetScale else 1

	-- t: 0..1 (нормализованное время)
	local function valueAt(t: number): number
		return target + (start - target) * math.exp(-damping * t) * math.cos(frequency * t) * amplitude
	end

	uiScale.Scale = valueAt(0)

	Animator.Run(self.wrapper, "SpringEffect", duration, function(t)
		uiScale.Scale = valueAt(t)
	end, function()
		uiScale.Scale = target
	end)
end

return SpringEffect
