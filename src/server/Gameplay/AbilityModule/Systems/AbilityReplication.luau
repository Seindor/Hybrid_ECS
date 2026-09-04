local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local AbilityReplicationOperations = require("../Operations/AbilityReplicationOperations")
local Components = require("../Data/Components")
local system = {}

function system.ReplicateAbility()
	for _, data in WorldPoint:query(Components.ReplicateAbilityRequestData) do
		AbilityReplicationOperations.AddAbilityReplication(data)
	end
end

return system
