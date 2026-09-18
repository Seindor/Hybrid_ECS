local jecs = require("@RbxPackages/jecs")
local Types = require("@SharedGameplay/PassiveModule/Data/Types")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local PassivesRegistry = require("../Resources/PassivesRegistry")

local operations = {}

function operations.ExecuteBehavior(
	owner: jecs.Entity,
	passive: jecs.Entity,
	operation: keyof<Types.IPassiveObject>,
	...
)
	local info = WorldPoint:get(passive, Components.PassiveInfo)
	if not info then return end

	local selectedBehavior: any = PassivesRegistry[info.name]
	assert(selectedBehavior, `{info.name} behavior isnt registered in passive registry!`)

	local selectedOperation = selectedBehavior[operation]
	if not selectedOperation then return end

	if operation == "OnAttach" then WorldPoint:add(passive, Components.PassiveActive) end
	if not WorldPoint:has(passive, Components.PassiveActive) then return end

	selectedOperation(owner, passive, ...)
end
-- ^ should use lazy init here?

return operations