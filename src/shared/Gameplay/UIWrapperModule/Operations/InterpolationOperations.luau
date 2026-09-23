--!strict
--[[
	Интерполяция UDim2: линейная и квадратичная Безье. t уже должен быть "eased".
]]

local operations = {}

-- t уже должен быть "eased"
function operations.LerpUDim2(a: UDim2, b: UDim2, t: number): UDim2
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
function operations.QuadraticBezierUDim2(p0: UDim2, p1: UDim2, p2: UDim2, t: number): UDim2
	return UDim2.new(
		quadratic(p0.X.Scale, p1.X.Scale, p2.X.Scale, t),
		quadratic(p0.X.Offset, p1.X.Offset, p2.X.Offset, t),
		quadratic(p0.Y.Scale, p1.Y.Scale, p2.Y.Scale, t),
		quadratic(p0.Y.Offset, p1.Y.Offset, p2.Y.Offset, t)
	)
end

return operations
