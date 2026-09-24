--!strict
local AnimationOperations = require("../../Operations/AnimationOperations")
local Components = require("../../Data/Components")
local EasingOperations = require("../../Operations/EasingOperations")
local InterpolationOperations = require("../../Operations/InterpolationOperations")
local Types = require("../../Data/Types")

local function emit(wrapper: Components.WrapperState, params: Types.MoveFrameParams?)
	local frame = wrapper.instance

	local duration = if params and params.duration then params.duration else 0
	local target = if params and params.target then params.target else UDim2.fromScale(0.5, 0.5)
	local style = EasingOperations.ResolveStyle(if params then params.style else nil)
	local direction = EasingOperations.ResolveDirection(if params then params.direction else nil)

	local start = frame.Position

	-- Изинг считается один раз за кадр, а не 4 раза (по разу на каждую компоненту UDim2)
	AnimationOperations.Run(wrapper, "MoveFrame", duration, function(alpha)
		frame.Position = InterpolationOperations.LerpUDim2(start, target, EasingOperations.Ease(alpha, style, direction))
	end, function()
		frame.Position = target
	end)
end

local effect: Components.Effect = {
	Emit = emit,
}

return effect
