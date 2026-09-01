local jecs = require("@RbxPackages/jecs")
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

	return attribute
end

return calculator
