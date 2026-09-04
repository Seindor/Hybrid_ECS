local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local BehaviorRegistry = require("../Resources/BehaviorRegistry")
local Types = require("../Data/Types")

local operations = {}

function operations.SelectBehavior(data: Types.PurchaseOperationRequestData)
	return BehaviorRegistry[data.name]
end

function operations.ExecuteBehavior(request: jecs.Entity, data: Types.PurchaseOperationRequestData)
	local behavior = operations.SelectBehavior(data)
	if not behavior then return end

	if behavior.Validate and not behavior.Validate(request) then return end
	if behavior.Deduct then behavior.Deduct(request) end
	if behavior.Grant then behavior.Grant(request) end
end

function operations.Validate(request: jecs.Entity, data: Types.PurchaseOperationRequestData): boolean
	local behavior = operations.SelectBehavior(data)
	if not behavior then return false end

	if behavior.Validate and not behavior.Validate(request) then return false end
	return true
end

return operations
