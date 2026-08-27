local App = require("@SharedCore/App/Services/App")
local Tokens = require("@SharedInternal/Dependencies/Tokens")
local AbilityValidatorsRegistry = require("./Resources/AbilityValidatorsRegistry")

return function(app: App.IApp)
	app:RegisterResource(Tokens.Registries.AbilityValidators, AbilityValidatorsRegistry)
end
