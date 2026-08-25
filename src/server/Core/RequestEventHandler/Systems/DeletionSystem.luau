local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local system = {}

function system.DestroyEvents()
	for entity in WorldPoint:query(Components.Event) do
		WorldPoint:delete(entity)
	end
end

function system.DestroyRequests()
	for entity in WorldPoint:query(Components.Request) do
		WorldPoint:delete(entity)
	end
end

return system
