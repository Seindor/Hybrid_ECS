local World = require("@SharedInternal/Dependencies/ECS/World").Resource
local Components = require("../Data/Components")

local operations = {}

function operations.Test(value)
	local entity = World:entity()
	World:set(entity, Components.Test, value)
	return entity
end

return operations
