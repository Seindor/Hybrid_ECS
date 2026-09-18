local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.AddStatusEffectReplication(data: Types.ReplicateStatusEffectRequestData)
	local container = WorldPoint:get(data.owner, Components.Shared.StatusEffectsContainer)
	if not container then return end

	local effect = container[data.effectName]
	if not effect then return end

	WorldPoint:set(effect, replecs.networked, data.players)
end

return operations