local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local MatchEventsOperations = require("../Operations/MatchEventsOperations")
local MatchPlayersOperations = require("../Operations/MatchPlayersOperations")
local Components = require("../Data/Components")
local system = {}

function system.PlayerAdded()
	for _, data in WorldPoint:query(Components.AddPlayerToMatchRequest) do
		MatchPlayersOperations.AddPlayer(data.match, data.player)
		MatchEventsOperations.EmitPlayerAddedEvent(data)
	end
end

function system.PlayerRemoved()
	for _, data in WorldPoint:query(Components.RemovePlayerFromMatchRequest) do
		MatchPlayersOperations.RemovePlayer(data.match, data.player)
		MatchEventsOperations.EmitPlayerRemovedEvent(data)
	end
end

return system
