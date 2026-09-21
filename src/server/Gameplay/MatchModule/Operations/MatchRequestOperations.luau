local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local RequestEventAPI = require("@ServerCore/RequestEventHandler/APIs/RequestEventAPI")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.RequestMatchReplication(data: Types.ReplicateMatchRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.ReplicateMatchRequest, data)
	return request
end

function operations.RequestMatchCreation(data: Types.CreateMatchRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.CreateMatchRequest, data)
	return request
end

function operations.RequestMatchDeletion(data: Types.DeleteMatchRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.DeleteMatchRequest, data)
	return request
end

return operations
