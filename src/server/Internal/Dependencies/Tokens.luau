local Profile = require("@Server/Internal/Dependencies/Datastores/Profile")
local Abilities = require("@Server/Internal/Dependencies/Registries/Abilities")
local Matches = require("@Server/Internal/Dependencies/Registries/Matches")
local MatchRounds = require("@Server/Internal/Dependencies/Registries/MatchRounds")

return {
	Datastores = {
		Profile = Profile,
	},
	Registries = {
		Abilities = Abilities,
		Matches = Matches,
		MatchRounds = MatchRounds,
	},
}
