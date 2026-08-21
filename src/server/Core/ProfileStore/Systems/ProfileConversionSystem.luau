local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local ProfileStoreOperations = require("../Operations/ProfileStoreOperations")
local Components = require("../Data/Components")
local ConvertProfileOperations = require("../Resources/ConvertProfileOperations")

local system = {}

function system.ConvertProfile()
	for entity, conversionData in WorldPoint:query(Components.ProfileConversion) do
		local data = ConvertProfileOperations.ConvertToStore(entity)
		ProfileStoreOperations.SaveToStore(conversionData.id, data)
	end
end

return system
