local World = require("@SharedInternal/Dependencies/ECS/World").Resource
local Components = require("../Data/Components")

local system = {}

function system.TestTick()
	for entity, data in World:query(Components.Test) do
		print(data)
	end
end

return system
