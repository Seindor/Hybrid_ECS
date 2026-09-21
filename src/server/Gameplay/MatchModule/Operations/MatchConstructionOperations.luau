local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Components = require("../Data/Components")
local MatchInfo = require("@SharedContent/Info/MatchInfo")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")
local SharedTypes = require("@SharedGameplay/MatchModule/Data/Types")

local operations = {}

function operations.CreateMatch(data: Types.CreateMatchRequestData): jecs.Entity?
	local matchInfoOriginal = MatchInfo[data.matchName]

	if not matchInfoOriginal then return nil end

	local matchInfo = sift.Dictionary.copyDeep(matchInfoOriginal) :: SharedTypes.MatchInfo
	matchInfo.Players = {}

	local entity = WorldPoint:entity()

	WorldPoint:set(entity, Components.Shared.MatchInfo, matchInfo)

	return entity
end

function operations.DeleteMatch(entity: jecs.Entity)
	WorldPoint:delete(entity)
end

return operations
