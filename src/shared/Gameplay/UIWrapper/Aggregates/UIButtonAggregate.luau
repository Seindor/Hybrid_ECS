--!strict
local Effects = require("../Components/Effects")
local TypedAggregates = require("../Types/TypedAggregates")
local UIAggregate = require("../Aggregates/UIAggregate")

local OPTIONS: UIAggregate.Options = {
	name = "UIButtonAggregate",
	effects = Effects.UIButtonEffectsPrototypes,
	events = {
		InputBegan = true,
		InputEnded = true,
		InputChanged = true,
		MouseEnter = true,
		MouseLeave = true,
		MouseMoved = true,
		MouseWheelForward = true,
		MouseWheelBackward = true,
		Activated = true,
		SecondaryActivated = true,
		MouseButton1Click = true,
		MouseButton1Down = true,
		MouseButton1Up = true,
		MouseButton2Click = true,
		MouseButton2Down = true,
		MouseButton2Up = true,
		Destroying = true,
	},
}

local UIButtonAggregate = {}

export type UIButtonAggregate<I = GuiButton> = TypedAggregates.IUIButtonAggregate<I>

function UIButtonAggregate.new(instance: GuiButton, onDestroy: ((any) -> ())?): UIButtonAggregate
	assert(instance:IsA("GuiButton"), "UIButtonAggregate: ожидается GuiButton")
	return UIAggregate.new(instance, OPTIONS, onDestroy) :: any
end

return UIButtonAggregate
