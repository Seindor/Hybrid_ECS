local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local RequestEventAPI = require("@ServerCore/RequestEventHandler/APIs/RequestEventAPI")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.RequestAbilityReplication(data: Types.ReplicateAbilityRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.ReplicateAbilityRequestData, data)
	return request
end

function operations.RequestAbilityCreation(data: Types.CreateAbilityRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.CreateAbilityRequestData, data)
	return request
end

function operations.RequestAbilityDeletion(data: Types.DestroyAbilityRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.DestroyAbilityRequestData, data)
	return request
end

return operations
