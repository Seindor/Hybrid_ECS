local jecs = require("@RbxPackages/jecs")
local AbilityStateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local Components = require("@SharedGameplay/AbilityModule/Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Shared = Components,

	PreviousState = WorldPoint:component() :: jecs.Component<AbilityStateMachine.Phases>,
}
