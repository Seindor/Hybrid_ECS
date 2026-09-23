local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local RequestEventAPI = require("../../../Core/RequestEventHandler/APIs/RequestEventAPI")
local Types = require("../Data/Types")
local operations = {}

function operations.RequestQuestCreation(data: Types.CreateQuestRequestData)
	local request = RequestEventAPI.CreateRequest()

	WorldPoint:set(request, Components.CreateQuestRequest, data)
end

function operations.RequestQuestDeletion(data: Types.DeleteQuestRequestData)
	local request = RequestEventAPI.CreateRequest()

	WorldPoint:set(request, Components.DeleteQuestRequest, data)
end

return operations
