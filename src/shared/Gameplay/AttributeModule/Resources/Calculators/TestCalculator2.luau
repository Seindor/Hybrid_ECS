local Types = require("../../Data/Types")

local calculator = {} :: Types.ICalculator

function calculator.Calculate(context: Types.ActionContext)
	local attribute = context.attribute

	attribute.value += 1
end

return calculator
