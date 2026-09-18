local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local RequestEventAPI = require("@ServerCore/RequestEventHandler/APIs/RequestEventAPI")
local Components = require("../Data/Components")
local Types = require("../Data/Types")

local operations = {}

function operations.ApplyStatusEffectRequest(data: Types.ApplyStatusEffectRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.ApplyStatusEffectRequestData, data)
	return request
end

function operations.RemoveStatusEffectRequest(data: Types.RemoveStatusEffectRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.RemoveStatusEffectRequestData, data)
	return request
end

function operations.ReplicateStatusEffectRequest(data: Types.ReplicateStatusEffectRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.ReplicateStatusEffectRequestData, data)
	return request
end

return operations