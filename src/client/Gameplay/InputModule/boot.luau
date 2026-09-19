local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local InputSystem = require("./Systems/InputSystem")

return function(app: App.IApp)
	app:RegisterSystem(InputSystem.ProcessBindInputs, RuntimePriorities.Request)
	app:RegisterSystem(InputSystem.ProcessUnbindInputs, RuntimePriorities.Request)
end