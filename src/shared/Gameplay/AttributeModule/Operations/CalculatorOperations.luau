local Types = require("../Data/Types")

local registry: { [string]: Types.ICalculator }?

local operations = {}

local function initRegistry()
	registry = require("../Resources/CalculatorRegistry")
	-- ^ lazy init to prevent dependency, could swap out for DI
end

function operations.SelectCalculator(attribute: Types.Attribute): Types.ICalculator?
	if not registry then initRegistry() end
	assert(registry, `failed to initialize calculator registry!`)

	local selectedCalculator = registry[attribute.calculator]
	if not selectedCalculator then return nil end

	return selectedCalculator
end

return operations
