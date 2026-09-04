local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local PassiveOperations = require("../Operations/PassiveOperations")
local Components = require("../Data/Components")
local system = {}

function system.OnTick()
	for entity, passiveContainer in WorldPoint:query(Components.PassiveContainer) do
		for _, passive in passiveContainer do
			PassiveOperations.ExecuteBehavior(entity, passive, "OnTick")
		end
	end
end

return system
