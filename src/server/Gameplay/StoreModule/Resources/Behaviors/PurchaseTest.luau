local Types = require("../../Data/Types")

local behavior = {} :: Types.IBehavior

function behavior.Grant(_request)
	print("granted product")
end

function behavior.Validate(_request)
	return true
end

return behavior
