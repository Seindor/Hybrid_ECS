local jecs = require("@RbxPackages/jecs")
local AttributeContainerOperations = require("../Operations/AttributeContainerOperations")
local AttributeOperations = require("../Operations/AttributeOperations")
local Types = require("../Data/Types")

local API = {}

function API.RecalculateContainerAttribute(owner: jecs.Entity, attributeName: string, context: Types.ActionContext?)
	local selectedAttribute = AttributeContainerOperations.GetAttributeFromContainer(owner, attributeName)
	if not selectedAttribute then return end

	local calculatedAttribute = AttributeOperations.CalculateAttribute(selectedAttribute, context or {})
	AttributeContainerOperations.SetAttributeToContainer(owner, attributeName, calculatedAttribute)
end

function API.GetContainerAttributeValue(owner: jecs.Entity, attributeName: string, context: Types.ActionContext?)
	API.RecalculateContainerAttribute(owner, attributeName, context)

	local selectedAttribute = AttributeContainerOperations.GetAttributeFromContainer(owner, attributeName)
	if not selectedAttribute then return 0 end
	return selectedAttribute.value
end

function API.CalculateAttribute(attribute: Types.Attribute, context: Types.ActionContext?)
	return AttributeOperations.CalculateAttribute(attribute, context or {})
end

function API.GetAttributeValue(attribute: Types.Attribute, context: Types.ActionContext?)
	return API.CalculateAttribute(attribute, context).value
end

return API
