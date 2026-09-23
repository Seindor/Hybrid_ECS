local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local QuestReplicationOperations = require("../Operations/QuestReplicationOperations")
local Components = require("../Data/Components")

local system = {}

function system.ReplicateAbility()
	for _, data in WorldPoint:query(Components.ReplicateQuestRequest) do
		QuestReplicationOperations.AddQuestReplication(data)
	end
end

return system
