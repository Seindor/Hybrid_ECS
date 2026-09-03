local jecs = require("@RbxPackages/jecs")
local PassivesRegistry = require("../Resources/PassivesRegistry")
local Types = require("../Data/Types")

local operations = {}

function operations.ExecuteBehavior(
	owner: jecs.Entity,
	passive: Types.Passive,
	operation: keyof<Types.IPassiveObject>,
	...
)
	local selectedBehavior: any = PassivesRegistry[passive.name]
	assert(selectedBehavior, `{passive.name} behavior isnt registered in passive registry!`)

	local selectedOperation = selectedBehavior[operation]
	if not selectedOperation then return end
	selectedOperation(owner, passive, ...)
end
-- ^ should use lazy init here?

return operations
