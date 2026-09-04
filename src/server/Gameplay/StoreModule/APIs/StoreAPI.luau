local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")
local BehaviorOperations = require("../Operations/BehaviorOperations")
local RequestOperations = require("../Operations/RequestOperations")

local API = {}

function API.RequestPurchase(data: Types.PurchaseOperationRequestData)
	RequestOperations.RequestPurchase(data)
end

function API.ValidatePurchase(data: Types.PurchaseOperationRequestData)
	local validationEntity = RequestOperations.RequestValidation(data)
	local result = BehaviorOperations.Validate(validationEntity, data)
	WorldPoint:delete(validationEntity)
	return result
end

return API
