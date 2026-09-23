--!strict
local Animator = require("../Animator")
local Easing = require("../Easing")
local TypedAggregates = require("../../Types/TypedAggregates")
local UIWrapperTypes = require("../../Types/UIWrapperTypes")

local MoveFrame = {}
MoveFrame.__index = MoveFrame

export type MoveFrame = typeof(setmetatable({} :: { wrapper: TypedAggregates.IEffectHost }, MoveFrame))

function MoveFrame.new(wrapper: TypedAggregates.IEffectHost): MoveFrame
	return setmetatable({ wrapper = wrapper }, MoveFrame)
end

function MoveFrame.Emit(self: MoveFrame, params: UIWrapperTypes.MoveFrameParams?)
	local frame = self.wrapper.instance

	local duration = if params and params.duration then params.duration else 0
	local target = if params and params.target then params.target else UDim2.fromScale(0.5, 0.5)
	local style = Easing.ResolveStyle(if params then params.style else nil)
	local direction = Easing.ResolveDirection(if params then params.direction else nil)

	local start = frame.Position

	-- Изинг считается один раз за кадр, а не 4 раза (по разу на каждую компоненту UDim2)
	Animator.Run(self.wrapper, "MoveFrame", duration, function(alpha)
		frame.Position = Easing.LerpUDim2(start, target, Easing.Ease(alpha, style, direction))
	end, function()
		frame.Position = target
	end)
end

return MoveFrame
