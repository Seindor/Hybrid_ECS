--!strict
--[[
	Изинг: разбор Enum/строк и TweenService:GetValue.
]]

local TweenService = game:GetService("TweenService")

local Types = require("../Data/Types")

local operations = {}

function operations.ResolveStyle(style: Types.EasingStyle?): Enum.EasingStyle
	if style == nil then return Enum.EasingStyle.Linear end

	if typeof(style) == "string" then
		local ok, item = pcall(function()
			return (Enum.EasingStyle :: any)[style]
		end)
		if ok and item then return item end
		warn(`[UIWrapper] Неизвестный EasingStyle "{style}", использую Linear`)
		return Enum.EasingStyle.Linear
	end

	return style :: Enum.EasingStyle
end

function operations.ResolveDirection(direction: Types.EasingDirection?): Enum.EasingDirection
	if direction == nil then return Enum.EasingDirection.In end

	if typeof(direction) == "string" then
		local ok, item = pcall(function()
			return (Enum.EasingDirection :: any)[direction]
		end)
		if ok and item then return item end
		warn(`[UIWrapper] Неизвестный EasingDirection "{direction}", использую In`)
		return Enum.EasingDirection.In
	end

	return direction :: Enum.EasingDirection
end

-- alpha 0..1 -> eased alpha
function operations.Ease(alpha: number, style: Enum.EasingStyle, direction: Enum.EasingDirection): number
	return TweenService:GetValue(alpha, style, direction)
end

return operations
