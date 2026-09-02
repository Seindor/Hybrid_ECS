local Types = require("@SharedGameplay/AttributeModule/Data/Types")
local AttributeCalculationAPI = require("../../APIs/AttributeCalculationAPI")
local QueryAdditiveModifiers = require("../CalculationSteps/QueryAdditiveModifiers")

local calculator = {} :: Types.ICalculator

function calculator.Calculate(context: Types.ActionContext)
	local attribute = context.attribute

	QueryAdditiveModifiers(context)

	local anotherAttribute = AttributeCalculationAPI.GetCalculatedContainerAttribute(context.owner, "Test2")

	attribute.value += anotherAttribute.value
end

return calculator
