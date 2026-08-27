local AbilityStateOperations = require("../Operations/AbilityStateOperations")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Replicator = require("@SharedInternal/Replication/Replicator")
local Components = require("../Data/Components")

local system = {}

function system.SyncState()
	for entity, state in WorldPoint:query(Components.Shared.State) do
		local serverOwner: any = WorldPoint:get(entity, Components.Shared.AbilityOwner)
		if not serverOwner then continue end

		local clientOwner = Replicator.client:get_client_entity(serverOwner)
		if not clientOwner then continue end

		AbilityStateOperations.ExecuteStateBehavior(entity, clientOwner, state)
	end
end

return system
