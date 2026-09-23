--!strict
--[[
	Чистые данные: какие события разрешены у каждого типа обёртки.
]]

local sift = require("@RbxPackages/sift")

local Common = {
	InputBegan = true,
	InputEnded = true,
	InputChanged = true,
	MouseEnter = true,
	MouseLeave = true,
	MouseMoved = true,
	MouseWheelForward = true,
	MouseWheelBackward = true,
	Destroying = true,
}

return {
	Button = sift.Dictionary.merge(Common, {
		Activated = true,
		SecondaryActivated = true,
		MouseButton1Click = true,
		MouseButton1Down = true,
		MouseButton1Up = true,
		MouseButton2Click = true,
		MouseButton2Down = true,
		MouseButton2Up = true,
	}) :: { [string]: boolean },

	Frame = sift.Dictionary.merge(Common, {
		Shown = true,
		Hidden = true,
	}) :: { [string]: boolean },
}
