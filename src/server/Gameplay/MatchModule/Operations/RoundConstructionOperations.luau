local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Components = require("../Data/Components")
local RoundsInfo = require("@SharedContent/Info/MatchRoundsInfo")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")
local SharedTypes = require("@SharedGameplay/MatchModule/Data/Types")

local operations = {}

function operations.CreateRound(data: Types.CreateRoundRequestData): jecs.Entity?
	local roundInfoOriginal = RoundsInfo[data.roundName]

	if not roundInfoOriginal then return nil end

	local roundInfo = sift.Dictionary.copyDeep(roundInfoOriginal) :: SharedTypes.RoundInfo

	local entity = WorldPoint:entity()

	WorldPoint:set(entity, Components.Shared.RoundInfo, roundInfo)

	return entity
end

function operations.DeleteMatch(entity: jecs.Entity)
	WorldPoint:delete(entity)
end

return operations
