local Abilities = require("@Client/Internal/Dependencies/Registries/Abilities")
local InputBehaviors = require("@Client/Internal/Dependencies/Registries/InputBehaviors")

return {
	Registries = {
		Abilities = Abilities,
		InputBehaviors = InputBehaviors,
	},
}