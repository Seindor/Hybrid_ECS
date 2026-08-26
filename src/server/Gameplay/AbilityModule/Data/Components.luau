local janitor = require("@RbxPackages/janitor")
local jecs = require("@RbxPackages/jecs")
local AbilityType = require("@SharedContent/Types/AbilityType")
local Components = require("@SharedGameplay/AbilityModule/Data/Components")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Shared = Components,
	-- ^ change it so that client and server components have references to the shared components scope
	-- this solution works but there should be a better one

	_abilityInternal = WorldPoint:component() :: jecs.Component<{
		currentThread: thread?,
		janitor: janitor.Janitor,
	}>,

	AbilityInfo = WorldPoint:component() :: jecs.Component<AbilityType.Ability>,
	Active = WorldPoint:component() :: jecs.Component<>,
	OnCD = WorldPoint:component() :: jecs.Component<>,
	Cooldown = WorldPoint:component() :: jecs.Component<{ passed: number }>, -- move into another time related module

	ReplicateAbilityRequestData = WorldPoint:component() :: jecs.Component<Types.ReplicateAbilityRequestData>,
	CreateAbilityRequestData = WorldPoint:component() :: jecs.Component<Types.CreateAbilityRequestData>,
	DestroyAbilityRequestData = WorldPoint:component() :: jecs.Component<Types.DestroyAbilityRequestData>,
}
