--!strict
--[[
	Подгоняет CanvasSize ScrollingFrame под содержимое UIListLayout.
	Подписки живут в janitor обёртки и умирают вместе с ней.
]]

local Components = require("../Data/Components")

local operations = {}

function operations.BindCanvasToLayout(
	wrapper: Components.WrapperState,
	scrollingFrame: ScrollingFrame,
	layout: UIListLayout,
	axis: ("X" | "Y")?
)
	local isVertical = axis ~= "X"

	local function update()
		local content = layout.AbsoluteContentSize
		local size = scrollingFrame.AbsoluteSize
		local padding = layout.Padding.Scale

		if isVertical then
			scrollingFrame.CanvasSize = UDim2.fromOffset(0, content.Y + padding * size.Y)
		else
			scrollingFrame.CanvasSize = UDim2.fromOffset(content.X + padding * size.X, 0)
		end
	end

	update()

	wrapper._janitor:Add(
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update),
		"Disconnect",
		"layout_AbsoluteContentSizeChanged"
	)

	wrapper._janitor:Add(
		scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(update),
		"Disconnect",
		"layout_AbsoluteSizeChanged"
	)
end

return operations
