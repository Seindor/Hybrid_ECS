local App = require("@SharedCore/App/Services/App")
local Tokens = require("@ClientInternal/Dependencies/Tokens")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local AbilityStateSync = require("./Systems/AbilityStateSync")
local AbilitiesRegistry = require("./Resources/AbilitiesRegistry")

return function(app: App.IApp)
	app:RegisterResource(Tokens.Registries.Abilities, AbilitiesRegistry)
	app:RegisterSystem(AbilityStateSync.SyncState, RuntimePriorities.Request)
end
