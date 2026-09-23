local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.AddQuestReplication(data: Types.ReplicateQuestRequestData)
	local container = WorldPoint:get(data.owner, Components.Shared.QuestsContainer)
	if not container then return end

	local quest = container[data.questName]
	if not quest then return end

	WorldPoint:set(quest, replecs.networked, data.players)
end

return operations
