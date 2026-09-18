local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.HasStatusEffect(owner: jecs.Entity, effectName: string): boolean
	local container = WorldPoint:get(owner, Components.Shared.StatusEffectsContainer)
	if not container then return false end
	return container[effectName] ~= nil
end

function operations.GetStatusEffect(owner: jecs.Entity, effectName: string): jecs.Entity?
	local container = WorldPoint:get(owner, Components.Shared.StatusEffectsContainer)
	if not container then return nil end
	return container[effectName]
end

function operations.AddStatusEffectToContainer(owner: jecs.Entity, effect: jecs.Entity): boolean
	local container: { [string]: jecs.Entity } = WorldPoint:get(owner, Components.Shared.StatusEffectsContainer) or {}
	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if not info then return false end

	container[info.name] = effect
	WorldPoint:set(owner, Components.Shared.StatusEffectsContainer, container)
	return true
end

function operations.RemoveStatusEffectFromContainer(owner: jecs.Entity, effectName: string): jecs.Entity?
	local container = WorldPoint:get(owner, Components.Shared.StatusEffectsContainer)
	if not container then return nil end

	local effect = container[effectName]
	container[effectName] = nil
	WorldPoint:set(owner, Components.Shared.StatusEffectsContainer, container)
	return effect
end

return operations