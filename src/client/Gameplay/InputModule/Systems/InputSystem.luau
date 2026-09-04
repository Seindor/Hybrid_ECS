local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local InputOperations = require("../Operations/InputOperations")

local system = {}

function system.ProcessBindInputs()
	for _, data in WorldPoint:query(Components.BindInputRequestData) do
		InputOperations.BindInput(data)
	end
end

function system.ProcessUnbindInputs()
	for _, data in WorldPoint:query(Components.UnbindInputRequestData) do
		InputOperations.UnbindInput(data)
	end
end

return system
