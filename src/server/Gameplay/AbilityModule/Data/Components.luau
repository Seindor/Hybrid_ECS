local janitor = require("@RbxPackages/janitor")
local jecs = require("@RbxPackages/jecs")
local StateMachine = require("./StateMachine")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	_abilityInternal = WorldPoint:component() :: jecs.Component<{
		currentThread: thread,
		janitor: janitor.Janitor,
	}>,

	State = WorldPoint:component() :: jecs.Component<StateMachine.Phases>,
	AbilityName = WorldPoint:component() :: jecs.Component<string>,
	AbilityInfo = WorldPoint:component() :: jecs.Component<{
		Duration: number,
	}>,
	Active = WorldPoint:component() :: jecs.Component<>,
	OnCD = WorldPoint:component() :: jecs.Component<>,
	Cooldown = WorldPoint:component() :: jecs.Component<{ passed: number }>, -- move into another time related module

	AbilityContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,
}
