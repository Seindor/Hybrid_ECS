local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.AddAbilityReplication(data: Types.ReplicateAbilityRequestData)
	local container = WorldPoint:get(data.owner, Components.Shared.AbilityContainer)
	if not container then return end

	local ability = container[data.abilityName]
	print(ability, container)
	if not ability then return end

	WorldPoint:set(ability, replecs.networked, data.players)
end

return operations
