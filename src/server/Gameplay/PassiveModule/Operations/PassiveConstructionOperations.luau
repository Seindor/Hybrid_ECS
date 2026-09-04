local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local operations = {}

function operations.CreateContainer(owner: jecs.Entity)
	local passiveContainer: any = WorldPoint:get(owner, Components.PassiveContainer) or {}
	WorldPoint:set(owner, Components.PassiveContainer, passiveContainer)
end

return operations
