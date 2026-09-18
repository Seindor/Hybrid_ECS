local jecs = require("@RbxPackages/jecs")
local Components = require("@SharedGameplay/StatusEffectModule/Data/Components")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Shared = Components,

	ApplyStatusEffectRequestData = WorldPoint:component() :: jecs.Component<Types.ApplyStatusEffectRequestData>,
	RemoveStatusEffectRequestData = WorldPoint:component() :: jecs.Component<Types.RemoveStatusEffectRequestData>,
	ReplicateStatusEffectRequestData = WorldPoint:component() :: jecs.Component<Types.ReplicateStatusEffectRequestData>,
}