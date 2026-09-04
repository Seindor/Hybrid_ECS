local jecs = require("@RbxPackages/jecs")
local RequestEventAPI = require("@ServerCore/RequestEventHandler/APIs/RequestEventAPI")
local AttributeConstructionAPI = require("@SharedGameplay/AttributeModule/APIs/AttributeConstructionAPI")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")
local PurchaseTypes = require("../Data/Types")

local operations = {}

local function setRequestCosts(request: jecs.Entity, data: PurchaseTypes.PurchaseOperationRequestData)
	for name, value in (data.costs or {}) do
		AttributeConstructionAPI.CreateAttribute(request, {
			calculatorName = "Currency", -- < im not too sure abt that
			name = name,
			value = value,
		})
	end
end

function operations.RequestPurchase(data: PurchaseTypes.PurchaseOperationRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.PurchaseRequestData, data)
	setRequestCosts(request, data)
	return request
end

function operations.RequestValidation(data: PurchaseTypes.PurchaseOperationRequestData)
	local request = RequestEventAPI.CreateRequest()
	WorldPoint:set(request, Components.ValidationRequestData, data)
	setRequestCosts(request, data)
	return request
end

--> validate > async prompt > event listener > apply reward > apply post reward

return operations
