local Types = require("../Data/Types")
local StatusEffectRequestOperations = require("../Operations/StatusEffectRequestOperations")

local API = {}

function API.ApplyStatusEffect(data: Types.ApplyStatusEffectRequestData)
	return StatusEffectRequestOperations.ApplyStatusEffectRequest(data)
end

function API.RemoveStatusEffect(data: Types.RemoveStatusEffectRequestData)
	return StatusEffectRequestOperations.RemoveStatusEffectRequest(data)
end

function API.ReplicateStatusEffect(data: Types.ReplicateStatusEffectRequestData)
	return StatusEffectRequestOperations.ReplicateStatusEffectRequest(data)
end

return API