local Types = require("@SharedGameplay/AttributeModule/Data/Types")
local ModifierContainerOperations = require("@SharedGameplay/AttributeModule/Operations/ModifierContainerOperations")

return function(context: Types.ActionContext)
	local attribute = context.attribute
	local additiveModifiers = ModifierContainerOperations.QueryModifiersByTags(context.owner, { "Add" })

	for _, modifier in additiveModifiers do
		attribute.value += modifier.value
	end
end
