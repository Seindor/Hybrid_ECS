local jecs = require("@RbxPackages/jecs")
local ModifierContainerOperations = require("../Operations/ModifierContainerOperations")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")

local API = {}

function API.CreateAttribute(owner: jecs.Entity, context: { name: string, value: number, calculatorName: string })
	local data: Types.Attribute = {
		value = context.value,
		baseValue = context.value,
		_dirty = false,
		calculator = context.calculatorName,
	}

	local container = WorldPoint:get(owner, Components.AttributesContainer) or {}
	container[context.name] = data
	WorldPoint:set(owner, Components.AttributesContainer, container :: any)
end

function API.CreateModifier(owner: jecs.Entity, context: { value: number, tags: { string } })
	local data = {
		value = context.value,
		tags = context.tags,
	}

	local id = ModifierContainerOperations.AddModifierToContainer(owner, data)

	local container = WorldPoint:get(owner, Components.ModifiersContainer)
	WorldPoint:set(owner, Components.ModifiersContainer, container :: any)

	return id
end

function API.RemoveModifier(owner: jecs.Entity, modifierId: string)
	ModifierContainerOperations.RemoveModifierFromContainer(owner, modifierId)
	local container = WorldPoint:get(owner, Components.ModifiersContainer) or {}
	WorldPoint:set(owner, Components.ModifiersContainer, container :: any)
end

return API
