local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local StatusEffectConstructionOperations = require("../Operations/StatusEffectConstructionOperations")
local StatusEffectContainerOperations = require("../Operations/StatusEffectContainerOperations")
local StatusEffectOperations = require("../Operations/StatusEffectOperations")

local system = {}

function system.ApplyStatusEffect()
	for _, data in WorldPoint:query(Components.ApplyStatusEffectRequestData) do
		local existing = StatusEffectContainerOperations.GetStatusEffect(data.owner, data.effectName)
		if existing then
			StatusEffectOperations.ReapplyStatusEffect(data.owner, existing, data.data)
			continue
		end

		local effect = StatusEffectConstructionOperations.CreateStatusEffect(data)
		if not effect then continue end

		StatusEffectContainerOperations.AddStatusEffectToContainer(data.owner, effect)
		StatusEffectOperations.ExecuteBehavior(data.owner, effect, "OnApply")
	end
end

return system