local Types = require("../Data/Types")
local MatchRequestOperations = require("../Operations/MatchRequestOperations")
local API = {}

function API.CreateMatch(data: Types.CreateMatchRequestData)
	MatchRequestOperations.RequestMatchCreation(data)
end

function API.DeleteMatch(data: Types.DeleteMatchRequestData)
	MatchRequestOperations.RequestMatchDeletion(data)
end

function API.ReplicateMatch(data: Types.ReplicateMatchRequestData)
	MatchRequestOperations.RequestMatchReplication(data)
end

return API
