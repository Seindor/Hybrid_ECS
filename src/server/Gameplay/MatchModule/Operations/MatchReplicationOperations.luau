local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")

local operations = {}

function operations.AddMatchReplication(data: Types.ReplicateMatchRequestData)
	WorldPoint:set(data.match, replecs.networked, data.players)
end

return operations
