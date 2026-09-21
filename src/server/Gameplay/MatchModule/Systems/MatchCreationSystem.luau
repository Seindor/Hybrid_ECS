local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local MatchEventsOperations = require("../Operations/MatchEventsOperations")
local MatchConstructionOperations = require("../Operations/MatchConstructionOperations")
local Components = require("../Data/Components")

local system = {}

function system.CreateMatch()
	for _, data in WorldPoint:query(Components.CreateMatchRequest) do
		local match = MatchConstructionOperations.CreateMatch(data)

		if not match then continue end

		MatchEventsOperations.EmitMatchCreatedEvent({ match = match })
	end
end

function system.DeleteMatch()
	for _, data in WorldPoint:query(Components.DeleteMatchRequest) do
		MatchEventsOperations.MatchRemovedEvent(data)
		MatchConstructionOperations.DeleteMatch({ entity = data })
	end
end

return system
