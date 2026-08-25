local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")

local operations = {}

function operations.CreateRequest()
	local entity = WorldPoint:entity()
	WorldPoint:add(entity, Components.Request)
	return entity
end

function operations.CreateEvent()
	local entity = WorldPoint:entity()
	WorldPoint:add(entity, Components.Event)
	return entity
end

return operations
