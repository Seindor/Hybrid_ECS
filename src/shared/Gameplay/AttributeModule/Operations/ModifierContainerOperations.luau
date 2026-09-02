local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local id = 0

local function generateId()
	id += 1
	return tostring(id)
end
-- ^ might cause issues on large numbers

local operations = {}

function operations.GetModifierFromContainer(owner: jecs.Entity, modifierId: string): Types.Modifier?
	local modifierContainer = WorldPoint:get(owner, Components.ModifiersContainer)
	if not modifierContainer then return nil end

	local selectedModifier = modifierContainer[modifierId]
	return selectedModifier
end

function operations.AddModifierToContainer(owner: jecs.Entity, modifier: Types.Modifier): string
	local modifierContainer = WorldPoint:get(owner, Components.ModifiersContainer)
	assert(modifierContainer, `{owner} entity doesnt have a modifier container component!`)

	local id = generateId()

	modifierContainer[id] = modifier
	return id
end

function operations.QueryModifiersByTags(owner: jecs.Entity, tags: { string })
	local modifierContainer = WorldPoint:get(owner, Components.ModifiersContainer)
	local query = {}
	if not modifierContainer then return query end

	local tagMap = {}
	for _, tag in tags do
		tagMap[tag] = true
	end

	for _, modifier in modifierContainer do
		local foundTags = 0

		for _, tag in modifier.tags do
			if tagMap[tag] then
				foundTags += 1
			end
		end

		if foundTags == #tags then table.insert(query, modifier) end
	end

	return query
end

return operations
