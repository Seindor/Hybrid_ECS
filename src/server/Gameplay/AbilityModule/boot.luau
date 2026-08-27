local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local Tokens = require("@ServerInternal/Dependencies/Tokens")
local AbilitiesRegistry = require("./Resources/AbilitiesRegistry")
local AbilityCreation = require("./Systems/AbilityCreation")
local AbilityReplication = require("./Systems/AbilityReplication")

return function(app: App.IApp)
	app:RegisterSystem(AbilityCreation.CreateAbility, RuntimePriorities.Request)
	app:RegisterSystem(AbilityReplication.ReplicateAbility, RuntimePriorities.PostRequest)

	app:RegisterResource(Tokens.Registries.Abilities, AbilitiesRegistry)
end
