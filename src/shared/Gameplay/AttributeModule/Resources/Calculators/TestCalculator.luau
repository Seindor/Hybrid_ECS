local jecs = require("@RbxPackages/jecs")
local AttributeOperations = require("../../Operations/AttributeOperations")
local AttributeContainerOperations = require("../../Operations/AttributeContainerOperations")
local Contexts = require("../Contexts")
local ModifierOperations = require("../../Operations/ModifierOperations")
local Types = require("../../Data/Types")

local calculator = {} :: Types.ICalculator

function calculator.Apply(context: Contexts.TestContext, attribute)
	local owner = context.owner
	local modifiers = ModifierOperations.QueryModifiersByTags(owner, attribute.tags)

	for _, modifier in modifiers do
		ModifierOperations.ApplyModifier(attribute, modifier, context :: any)
	end

	local testAttribute = AttributeContainerOperations.GetAttributeFromContainer(owner, "Test2")
	if not testAttribute then return attribute end

	local changedAttribute = AttributeOperations.CalculateAttribute(testAttribute, context :: any)

	attribute.value = attribute.value * changedAttribute.value

	print(attribute.value)

	return attribute
end

return calculator
