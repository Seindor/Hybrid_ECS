local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local jecs = require("@RbxPackages/jecs")
local AbilityStateMachine = require("./AbilityStateMachine")

return {
	State = WorldPoint:component() :: jecs.Component<AbilityStateMachine.Phases>,
	AbilityContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,
}
