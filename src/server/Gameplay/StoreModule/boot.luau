local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local PurchaseRequestSystem = require("./Systems/PurchaseRequestSystem")

return function(app: App.IApp)
	app:RegisterSystem(PurchaseRequestSystem.ProcessPurchases, RuntimePriorities.Request)
end
