--!strict
--[[
	Подгоняет CanvasSize ScrollingFrame под UIListLayout внутри него.
]]

local WrapperCanvasOperations = require("../Operations/WrapperCanvasOperations")
local FrameCreationSystem = require("./FrameCreationSystem")

local system = {}

function system.FixCanvas(scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?)
	local layout = scrollingFrame:FindFirstChildWhichIsA("UIListLayout")
	if not layout then return end

	local wrapper = FrameCreationSystem.Create(scrollingFrame)
	WrapperCanvasOperations.BindCanvasToLayout(wrapper._state, scrollingFrame, layout, axis)
end

return system
