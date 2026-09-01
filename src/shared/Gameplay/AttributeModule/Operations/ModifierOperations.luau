local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")
local BehaviorRegistry = require("../Resources/BehaviorRegistry")

local operations = {}

function operations.CanApplyModifier(attribute: Types.Attribute, modifier: Types.Modifier, context: Types.ActionContext)
	local selectedBehavior = BehaviorRegistry[modifier.behavior]
	if not selectedBehavior then return false end

	return selectedBehavior.Check(context, attribute, modifier)
end

function operations.ApplyModifier(attribute: Types.Attribute, modifier: Types.Modifier, context: Types.ActionContext)
	if not operations.CanApplyModifier(attribute, modifier, context) then return end

	local selectedBehavior = BehaviorRegistry[modifier.behavior]
	if not selectedBehavior then return end

	selectedBehavior.Apply(context, attribute, modifier)
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

-- ^ should be separate in different files by the scope

return operations
