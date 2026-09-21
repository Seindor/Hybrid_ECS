local WorldPoint = require("../../../Internal/ECS/WorldPoint")
local jecs = require("../../../RbxPackages/jecs")
local MatchStateMachine = require("./MatchStateMachine")
local RoundStateMachine = require("./RoundStateMachine")
local Types = require("./Types")

return {

	MatchesContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,

	MatchState = WorldPoint:component() :: jecs.Component<MatchStateMachine.Phases>,
	RoundState = WorldPoint:component() :: jecs.Component<RoundStateMachine.Phases>,

	MatchInfo = WorldPoint:component() :: jecs.Component<Types.MatchInfo>,
	RoundInfo = WorldPoint:component() :: jecs.Component<Types.RoundInfo>,

	Rounds = WorldPoint:component() :: jecs.Component<{ [number]: jecs.Entity }>,
}
