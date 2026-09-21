local Types = require("./Types")
local janitor = require("@RbxPackages/janitor")
local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local sharedComponents = require("@SharedGameplay/MatchModule/Data/Components")

return {
	Shared = sharedComponents,

	_matchInternal = WorldPoint:component() :: jecs.Component<{
		currentThread: thread?,
		janitor: janitor.Janitor,
	}>,

	CreateMatchRequest = WorldPoint:component() :: jecs.Component<Types.CreateMatchRequestData>,
	DeleteMatchRequest = WorldPoint:component() :: jecs.Component<Types.DeleteMatchRequestData>,

	CreateRoundRequest = WorldPoint:component() :: jecs.Component<Types.CreateRoundRequestData>,
	DeleteRoundRequest = WorldPoint:component() :: jecs.Component<Types.DeleteRoundRequestData>,

	AddPlayerToMatchRequest = WorldPoint:component() :: jecs.Component<Types.AddPlayerToMatchRequestData>,
	RemovePlayerFromMatchRequest = WorldPoint:component() :: jecs.Component<Types.RemovePlayerFromMatchRequestData>,

	StartMatchRequest = WorldPoint:component() :: jecs.Component<Types.StartMatchRequestData>,
	EndMatchRequest = WorldPoint:component() :: jecs.Component<Types.EndMatchRequestData>,

	ReplicateMatchRequest = WorldPoint:component() :: jecs.Component<Types.ReplicateMatchRequestData>,

	MatchCreatedEvent = WorldPoint:component() :: jecs.Component<Types.MatchCreatedEventData>,
	MatchRemovedEvent = WorldPoint:component() :: jecs.Component<Types.MatchRemovedEventData>,

	PlayerAddedEvent = WorldPoint:component() :: jecs.Component<Types.PlayerAddedEventData>,
	PlayerRemovedEvent = WorldPoint:component() :: jecs.Component<Types.PlayerRemovedEventData>,
}
