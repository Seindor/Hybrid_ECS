--!strict
local Effects = require(script.Parent.Parent.Components.Effects)
local TypedAggregates = require(script.Parent.Parent.Types.TypedAggregates)
local UIAggregate = require(script.Parent.UIAggregate)
local UIWrapperTypes = require(script.Parent.Parent.Types.UIWrapperTypes)

local OPTIONS: UIAggregate.Options = {
	name = "UIFrameAggregate",
	effects = Effects.UIFrameEffectsPrototypes,
	events = {
		InputBegan = true,
		InputEnded = true,
		InputChanged = true,
		MouseEnter = true,
		MouseLeave = true,
		MouseMoved = true,
		MouseWheelForward = true,
		MouseWheelBackward = true,
		Shown = true,
		Hidden = true,
		Destroying = true,
	},
}

local UIFrameAggregate = {}

export type UIFrameAggregate<I = GuiObject> = TypedAggregates.IUIFrameAggregate<I>

function UIFrameAggregate.new(instance: UIWrapperTypes.FrameInstanceType, onDestroy: ((any) -> ())?): UIFrameAggregate
	return UIAggregate.new(instance, OPTIONS, onDestroy) :: any
end

return UIFrameAggregate
