--!strict
local AnimationOperations = require("../../Operations/AnimationOperations")
local Components = require("../../Data/Components")
local Types = require("../../Data/Types")
local UIScaleOperations = require("../../Operations/UIScaleOperations")

--[[
	Затухающая пружина от startScale к targetScale.
	amplitude: 1 = обычная раскачка, >1 - сильнее.
]]
local function emit(wrapper: Components.WrapperState, params: Types.SpringEffectParams?)
	local uiScale = UIScaleOperations.FindUIScale(wrapper.instance, "SpringEffect")
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

	AnimationOperations.Run(wrapper, "SpringEffect", duration, function(t)
		uiScale.Scale = valueAt(t)
	end, function()
		uiScale.Scale = target
	end)
end

local effect: Components.Effect = {
	Emit = emit,
}

return effect
