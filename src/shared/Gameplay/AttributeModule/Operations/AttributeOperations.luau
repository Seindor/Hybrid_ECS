local sift = require("@RbxPackages/sift")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local jecs = require("@RbxPackages/jecs")
local Types = require("../Data/Types")
local CalculatorRegistry = require("../Resources/CalculatorRegistry")

local operations = {}

function operations.ResetAttribute(attribute: Types.Attribute, context: Types.ActionContext)
	attribute.value = attribute.baseValue
end

function operations.CalculateAttribute(attribute: Types.Attribute, context: Types.ActionContext)
	local clonnedAttribute = sift.Dictionary.copyDeep(attribute)
	operations.ResetAttribute(attribute, context)

	local selectedCalculator = CalculatorRegistry[attribute.calculator]
	if not selectedCalculator then return attribute end
	return selectedCalculator.Apply(context, clonnedAttribute)
end

return operations
