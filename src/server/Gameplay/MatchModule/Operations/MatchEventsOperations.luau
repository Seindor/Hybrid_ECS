local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local RequestEventAPI = require("../../../Core/RequestEventHandler/APIs/RequestEventAPI")
local Types = require("../Data/Types")

local events = {}

function events.EmitPlayerAddedEvent(data: Types.PlayerAddedEventData)
	local event = RequestEventAPI.CreateEvent()
	WorldPoint:set(event, Components.PlayerAddedEvent, data)
end

function events.EmitPlayerRemovedEvent(data: Types.PlayerRemovedEventData)
	local event = RequestEventAPI.CreateEvent()
	WorldPoint:set(event, Components.PlayerRemovedEvent, data)
end

function events.EmitMatchCreatedEvent(data: Types.MatchCreatedEventData)
	local event = RequestEventAPI.CreateEvent()
	WorldPoint:set(event, Components.MatchCreatedEvent, data)
end

function events.MatchRemovedEvent(data: Types.MatchRemovedEventData)
	local event = RequestEventAPI.CreateEvent()
	WorldPoint:set(event, Components.MatchRemovedEvent, data)
end

return events
