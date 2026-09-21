local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.AddPlayer(match: jecs.Entity, player: jecs.Entity)
	local matchInfo = WorldPoint:get(match, Components.Shared.MatchInfo)

	assert(matchInfo, `no match info for {match}`)

	if sift.Array.has(matchInfo.Players, player) then return end
	if matchInfo.MaxPlayers >= #matchInfo.Players then return end

	sift.Array.append(matchInfo.Players, player)
end

function operations.RemovePlayer(match: jecs.Entity, player: jecs.Entity)
	local matchInfo = WorldPoint:get(match, Components.Shared.MatchInfo)

	assert(matchInfo, `no match info for {match}`)

	if not sift.Array.has(matchInfo.Players, player) then return end
	sift.Array.removeValue(matchInfo.Players, player)
end

return operations
