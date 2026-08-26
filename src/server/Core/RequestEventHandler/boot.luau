local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local DeletionSystem = require("./Systems/DeletionSystem")

return function(app: App.IApp)
	app:RegisterSystem(DeletionSystem.DestroyEvents, RuntimePriorities.Cleanup)
	app:RegisterSystem(DeletionSystem.DestroyRequests, RuntimePriorities.Cleanup)
end
