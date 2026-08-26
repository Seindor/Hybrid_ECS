local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local AbilityEventOperations = require("../Operations/AbilityEventOperations")
local AbilityContainerOperations = require("../Operations/AbilityContainerOperations")
local AbilityConstructionOperations = require("../Operations/AbilityConstructionOperations")
local Components = require("../Data/Components")

local system = {}

function system.CreateAbility()
	for entity, data in WorldPoint:query(Components.CreateAbilityRequestData) do
		local ability = AbilityConstructionOperations.CreateAbility(data)
		if not ability then return end
		AbilityContainerOperations.AddAbilityToContainer(data.owner, ability)
		AbilityEventOperations.EmitAbilityCreation()
	end
end

function system.DestroyAbility()
	for entity, data in WorldPoint:query(Components.DestroyAbilityRequestData) do
		local ability = AbilityContainerOperations.RemoveAbilityFromContainer(data.owner, data.abilityName)
		if not ability then continue end
		AbilityConstructionOperations.DestroyAbility(ability)
		AbilityEventOperations.EmitAbilityDeletion()
	end
end

return system
