local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local ProfileStoreAPI = require("../APIs/ProfileStoreAPI")
local Components = require("../Data/Components")
local system = {}

function system.ConvertProfile()
	for entity, conversionData in WorldPoint:query(Components.ProfileConversion) do
		ProfileStoreAPI.SavePlayer(conversionData.player, entity)
	end
end

return system
