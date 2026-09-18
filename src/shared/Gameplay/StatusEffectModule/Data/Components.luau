local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local TimerComponents = require("@SharedGameplay/TimerModule/Data/Components")

return {
	StatusEffectsContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,
	StatusEffectInfo = WorldPoint:component() :: jecs.Component<Types.StatusEffectInfo>,
	StatusEffectOwner = WorldPoint:component() :: jecs.Component<jecs.Entity>,
	StatusEffectStacks = WorldPoint:component() :: jecs.Component<number>,
	StatusEffectPermanent = WorldPoint:component() :: jecs.Component<>,
	Timers = TimerComponents.TimerContainer :: jecs.Component<Types.StatusEffectTimers>,
}