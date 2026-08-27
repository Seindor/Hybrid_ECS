local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local TimerSystem = require("./Systems/TimerSystem")

return function(app: App.IApp)
	app:RegisterSystem(TimerSystem.UpdateTimers, RuntimePriorities.Request)
end
