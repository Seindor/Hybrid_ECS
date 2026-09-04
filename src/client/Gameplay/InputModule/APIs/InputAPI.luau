local Types = require("../Data/Types")
local InputRequestOperations = require("../Operations/InputRequestOperations")

local API = {}

function API.BindInput(data: Types.BindInputRequestData)
	InputRequestOperations.RequestBindInput(data)
end

function API.UnbindInput(data: Types.UnbindInputRequestData)
	InputRequestOperations.RequestUnbindInput(data)
end

return API