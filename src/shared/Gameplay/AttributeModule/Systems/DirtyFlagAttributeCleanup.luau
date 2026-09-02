local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local system = {}

function system.Cleanup()
	for entity, attributesContainer in WorldPoint:query(Components.AttributesContainer) do
		for _, attribute in attributesContainer do
			attribute._dirty = false
		end
	end
end

return system
