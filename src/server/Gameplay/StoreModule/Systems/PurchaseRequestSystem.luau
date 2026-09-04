local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local BehaviorOperations = require("../Operations/BehaviorOperations")
local Components = require("../Data/Components")
local system = {}

function system.ProcessPurchases()
	for request, data in WorldPoint:query(Components.PurchaseRequestData) do
		BehaviorOperations.ExecuteBehavior(request, data)
	end
end

return system
