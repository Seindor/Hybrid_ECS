local Adapter = require("@SharedInternal/Dependencies/Test/Adapter").Resource

local operations = {}

function operations.Test()
	Adapter:Test()
end

return operations
