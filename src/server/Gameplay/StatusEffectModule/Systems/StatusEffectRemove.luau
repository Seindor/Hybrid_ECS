local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local StatusEffectContainerOperations = require("../Operations/StatusEffectContainerOperations")
local StatusEffectOperations = require("../Operations/StatusEffectOperations")

local system = {}

function system.RemoveStatusEffect()
	for _, data in WorldPoint:query(Components.RemoveStatusEffectRequestData) do
		local effect = StatusEffectContainerOperations.GetStatusEffect(data.owner, data.effectName)
		if not effect then continue end

		StatusEffectOperations.RemoveStatusEffect(data.owner, effect)
	end
end

return system