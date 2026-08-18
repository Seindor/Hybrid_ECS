local Test = require("@SharedInternal/Dependencies/Test/Test").Resource

local service = {}
service.__index = service

function service.new()
	local self = setmetatable({}, service)

	return self
end

return service
