local App = require("@SharedCore/App/Services/App")
local Tokens = require("@ClientInternal/Dependencies/Tokens")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local InputSystem = require("./Systems/InputSystem")
local InputBehaviorsRegistry = require("./Resources/InputBehaviorsRegistry")

return function(app: App.IApp)
	app:RegisterResource(Tokens.Registries.InputBehaviors, InputBehaviorsRegistry)
	app:RegisterSystem(InputSystem.ProcessBindInputs, RuntimePriorities.Request)
	app:RegisterSystem(InputSystem.ProcessUnbindInputs, RuntimePriorities.Request)
end