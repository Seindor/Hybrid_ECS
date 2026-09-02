local jecs = require("@RbxPackages/jecs")
local AttributeContainerOperations = require("../Operations/AttributeContainerOperations")
local AttributeOperations = require("../Operations/AttributeOperations")
local Types = require("../Data/Types")

local API = {}

function API.CalculateAttribute(owner: jecs.Entity, attribute: Types.Attribute)
	AttributeOperations.CalculateAttribute(owner, attribute)
end

function API.GetContainerAttribute(owner: jecs.Entity, attributeName: string)
	local selectedAttribute = AttributeContainerOperations.GetAttributeFromContainer(owner, attributeName)
	assert(selectedAttribute, `{attributeName} attribute doesnt exist on entity {owner}`)
	return selectedAttribute
end

function API.GetCalculatedContainerAttribute(owner: jecs.Entity, attributeName: string)
	local attribute = API.GetCalculatedContainerAttribute(owner, attributeName)
	API.CalculateAttribute(owner, attribute)
	return attribute
end

return API
