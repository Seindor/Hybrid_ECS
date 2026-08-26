local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local AbilityCreation = require("./Systems/AbilityCreation")
local AbilityReplication = require("./Systems/AbilityReplication")

return function(app: App.IApp)
	app:RegisterSystem(AbilityCreation.CreateAbility, RuntimePriorities.Request)
	app:RegisterSystem(AbilityReplication.ReplicateAbility, RuntimePriorities.PostRequest)
end
