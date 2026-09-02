local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.GetAttributeFromContainer(owner: jecs.Entity, attributeName: string): Types.Attribute?
	local attributeContainer = WorldPoint:get(owner, Components.AttributesContainer)
	assert(attributeContainer, `{owner} entity doesnt have an attribute container component!`)
	if not attributeContainer then return nil end

	local selectedAttribute = attributeContainer[attributeName]
	if not selectedAttribute then return nil end

	return selectedAttribute
end

function operations.SetAttributeToContainer(owner: jecs.Entity, attributeName: string, attribute: Types.Attribute)
	local attributeContainer = WorldPoint:get(owner, Components.AttributesContainer)
	if not attributeContainer then return end

	attributeContainer[attributeName] = attribute
end

return operations
