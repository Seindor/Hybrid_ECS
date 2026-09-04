local Types = require("../../Data/Types")

local behavior = {} :: Types.IBehavior

function behavior.Grant(request)
	print("granted product")
end

function behavior.Validate(request)
	return true
end

return behavior
