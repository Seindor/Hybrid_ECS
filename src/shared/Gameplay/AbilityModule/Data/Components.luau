local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local jecs = require("@RbxPackages/jecs")
local AbilityType = require("@SharedContent/Types/AbilityType")
local AbilityStateMachine = require("./AbilityStateMachine")

local TimerComponents = require("../../TimerModule/Data/Components")
local TimerTypes = require("../../TimerModule/Data/Types")

return {
	UsingAbility = WorldPoint:component() :: jecs.Component<>,

	State = WorldPoint:component() :: jecs.Component<AbilityStateMachine.Phases>,
	AbilityContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,
	Timers = TimerComponents.TimerContainer :: jecs.Component<{
		CD: TimerTypes.Timer,
	}>,

	AbilityInfo = WorldPoint:component() :: jecs.Component<AbilityType.Ability>,
	Active = WorldPoint:component() :: jecs.Component<>,
	OnCD = WorldPoint:component() :: jecs.Component<>,

	AbilityOwner = WorldPoint:component() :: jecs.Component<jecs.Entity>,
}
