local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local Tokens = require("@ServerInternal/Dependencies/Tokens")
local MatchesRegistry = require("./Resources/MatchesRegistry")
local RoundsRegistry = require("./Resources/RoundsRegistry")

local MatchCreationSystem = require("./Systems/MatchCreationSystem")
local RoundCreationSystem = require("./Systems/RoundCreationSystem")

--local MatchReplication = require("./Systems/MatchReplicationSystem")

return function(app: App.IApp)
	app:RegisterSystem(MatchCreationSystem.CreateMatch, RuntimePriorities.Request)
	app:RegisterSystem(RoundCreationSystem.CreateRound, RuntimePriorities.Request)

	--app:RegisterSystem(MatchReplication.ReplicateMatch, RuntimePriorities.PostRequest)

	app:RegisterResource(Tokens.Registries.Matches, MatchesRegistry)
	app:RegisterResource(Tokens.Registries.MatchRounds, RoundsRegistry)
end
