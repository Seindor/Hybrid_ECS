--!strict
--[[
	Небольшая замена TweenMath: изинг через TweenService:GetValue + Безье.
	Если хочешь - подмени на свой TweenMath, интерфейс тут минимальный.
]]

local TweenService = game:GetService("TweenService")

local Types = require(script.Parent.Parent.Types.UIWrapperTypes)

local Easing = {}

function Easing.ResolveStyle(style: Types.EasingStyle?): Enum.EasingStyle
	if style == nil then
		return Enum.EasingStyle.Linear
	end

	if typeof(style) == "string" then
		local ok, item = pcall(function()
			return (Enum.EasingStyle :: any)[style]
		end)
		if ok and item then
			return item
		end
		warn(`[UIWrapper] Неизвестный EasingStyle "{style}", использую Linear`)
		return Enum.EasingStyle.Linear
	end

	return style :: Enum.EasingStyle
end

function Easing.ResolveDirection(direction: Types.EasingDirection?): Enum.EasingDirection
	if direction == nil then
		return Enum.EasingDirection.In
	end

	if typeof(direction) == "string" then
		local ok, item = pcall(function()
			return (Enum.EasingDirection :: any)[direction]
		end)
		if ok and item then
			return item
		end
		warn(`[UIWrapper] Неизвестный EasingDirection "{direction}", использую In`)
		return Enum.EasingDirection.In
	end

	return direction :: Enum.EasingDirection
end

-- alpha 0..1 -> eased alpha
function Easing.Ease(alpha: number, style: Enum.EasingStyle, direction: Enum.EasingDirection): number
	return TweenService:GetValue(alpha, style, direction)
end

-- t уже должен быть "eased"
function Easing.LerpUDim2(a: UDim2, b: UDim2, t: number): UDim2
	return UDim2.new(
		a.X.Scale + (b.X.Scale - a.X.Scale) * t,
		a.X.Offset + (b.X.Offset - a.X.Offset) * t,
		a.Y.Scale + (b.Y.Scale - a.Y.Scale) * t,
		a.Y.Offset + (b.Y.Offset - a.Y.Offset) * t
	)
end

local function quadratic(p0: number, p1: number, p2: number, t: number): number
	local u = 1 - t
	return u * u * p0 + 2 * u * t * p1 + t * t * p2
end

-- Квадратичная кривая Безье: p0 (старт) -> p1 (контрольная) -> p2 (конец)
function Easing.QuadraticBezierUDim2(p0: UDim2, p1: UDim2, p2: UDim2, t: number): UDim2
	return UDim2.new(
		quadratic(p0.X.Scale, p1.X.Scale, p2.X.Scale, t),
		quadratic(p0.X.Offset, p1.X.Offset, p2.X.Offset, t),
		quadratic(p0.Y.Scale, p1.Y.Scale, p2.Y.Scale, t),
		quadratic(p0.Y.Offset, p1.Y.Offset, p2.Y.Offset, t)
	)
end

return Easing
