local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local StatusEffectOperations = require("../Operations/StatusEffectOperations")

local system = {}

function system.OnTick()
	for owner, container in WorldPoint:query(Components.Shared.StatusEffectsContainer) do
		for _, effect in container do
			StatusEffectOperations.ExecuteBehavior(owner, effect, "OnTick")
			StatusEffectOperations.HandleDoneTimers(owner, effect)
		end
	end
end

return system