local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local operations = {}

local function canAddAbility()
	return true
end

-- ^ move to validators

function operations.AddAbilityToContainer(owner: jecs.Entity, ability: jecs.Entity)
	local container = WorldPoint:get(owner, Components.Shared.AbilityContainer)
	if not container then return end

	if not canAddAbility() then return end

	local abilityInfo = WorldPoint:get(ability, Components.Shared.AbilityInfo)
	if not abilityInfo then return end

	container[abilityInfo.Name] = ability
	WorldPoint:set(owner, Components.Shared.AbilityContainer, container)
end

function operations.RemoveAbilityFromContainer(owner: jecs.Entity, abilityName: string): jecs.Entity?
	local container: { [string]: any } = WorldPoint:get(owner, Components.Shared.AbilityContainer)
	if not container then return nil end

	local ability = container[abilityName]
	container[abilityName] = nil

	WorldPoint:set(owner, Components.Shared.AbilityContainer, container)
	return ability
end

function operations.GetAbilityFromContainer(owner: jecs.Entity, abilityName: string): jecs.Entity?
	local container = WorldPoint:get(owner, Components.Shared.AbilityContainer)
	if not container then return nil end

	return container[abilityName]
end

return operations
