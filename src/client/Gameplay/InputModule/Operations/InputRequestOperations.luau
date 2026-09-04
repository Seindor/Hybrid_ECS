local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.RequestBindInput(data: Types.BindInputRequestData)
	local request = WorldPoint:entity()
	WorldPoint:set(request, Components.BindInputRequestData, data)
	return request
end

function operations.RequestUnbindInput(data: Types.UnbindInputRequestData)
	local request = WorldPoint:entity()
	WorldPoint:set(request, Components.UnbindInputRequestData, data)
	return request
end

return operations