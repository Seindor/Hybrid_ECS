local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local PassiveSubcriber = require("./Systems/PassiveSubcriber")

return function(app: App.IApp)
	app:RegisterSystem(PassiveSubcriber.OnTick, RuntimePriorities.PreEvent)
end
