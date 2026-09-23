--!strict
local Registry = require("../Data/Registry")
local WrapperCanvasOperations = require("../Operations/WrapperCanvasOperations")
local WrapperLifecycleSystem = require("./WrapperLifecycleSystem")

local system = {}

function system.FixCanvas(registry: Registry.Registry, scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?)
	local layout = scrollingFrame:FindFirstChildWhichIsA("UIListLayout")
	if not layout then return end

	local wrapper = WrapperLifecycleSystem.Create(registry, scrollingFrame)
	WrapperCanvasOperations.BindCanvasToLayout(wrapper, scrollingFrame, layout, axis)
end

return system
