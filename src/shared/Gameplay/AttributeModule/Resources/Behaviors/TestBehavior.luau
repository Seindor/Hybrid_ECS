local Types = require("../../Data/Types")

local behavior = {} :: Types.IBehavior

function behavior.Apply(context, attribute, modifier)
	attribute.value = attribute.value * modifier.additional.value
	return attribute
end

function behavior.Check(context, attribute, modifier)
	return true
end

return behavior
