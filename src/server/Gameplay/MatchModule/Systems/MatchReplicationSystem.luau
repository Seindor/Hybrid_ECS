local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local MatchReplicationOperations = require("../Operations/MatchReplicationOperations")
local system = {}

function system.ReplicateMatch()
	for _, data in WorldPoint:query(Components.ReplicateMatchRequest) do
		MatchReplicationOperations.AddMatchReplication(data)
	end
end

return system
