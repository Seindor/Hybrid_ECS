local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local CalculatorOperations = require("./CalculatorOperations")
local Types = require("../Data/Types")

local operations = {}

function operations.ResetAttribute(attribute: Types.Attribute)
	attribute.value = attribute.baseValue
end

function operations.CalculateAttribute(owner: jecs.Entity, attribute: Types.Attribute)
	if attribute._dirty then return end

	local context: Types.ActionContext = {
		owner = owner,
		attribute = attribute,
		additional = {},
	}

	local calculator = CalculatorOperations.SelectCalculator(attribute)
	assert(calculator, `{attribute} attribute has an undefined calculator`)

	attribute._dirty = true

	calculator.Calculate(context)
end

return operations
