local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local RoundConstructionOperations = require("../Operations/RoundConstructionOperations")
local system = {}

function system.CreateRound()
	for _, data in WorldPoint:query(Components.CreateRoundRequest) do
		local round = RoundConstructionOperations.CreateRound(data)

		if not round then continue end
	end
end

return system
