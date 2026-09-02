local ModifierContainerOperations = require("@SharedGameplay/AttributeModule/Operations/ModifierContainerOperations")
local Types = require("@SharedGameplay/AttributeModule/Data/Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local AttributeCalculationAPI = require("../../APIs/AttributeCalculationAPI")
local AttributeOperations = require("../../Operations/AttributeOperations")
local TestCalculator2 = require("./TestCalculator2")
local QueryAdditiveModifiers = require("../CalculationSteps/QueryAdditiveModifiers")
local AttributeContainerOperations = require("../../Operations/AttributeContainerOperations")
local Components = require("@SharedGameplay/AttributeModule/Data/Components")

local calculator = {} :: Types.ICalculator

function calculator.Calculate(context: Types.ActionContext)
	local attribute = context.attribute

	QueryAdditiveModifiers(context)

	local anotherAttribute = AttributeCalculationAPI.GetCalculatedContainerAttribute(context.owner, "Test2")

	attribute.value += anotherAttribute.value
end

return calculator
