local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local StatusEffectReplicationOperations = require("../Operations/StatusEffectReplicationOperations")

local system = {}

function system.ReplicateStatusEffect()
	for _, data in WorldPoint:query(Components.ReplicateStatusEffectRequestData) do
		StatusEffectReplicationOperations.AddStatusEffectReplication(data)
	end
end

return system