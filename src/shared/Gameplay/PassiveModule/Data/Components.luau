local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	PassiveContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,
	PassiveInfo = WorldPoint:component() :: jecs.Component<Types.PassiveInfo>,
	PassiveOwner = WorldPoint:component() :: jecs.Component<jecs.Entity>,
	PassiveActive = WorldPoint:component() :: jecs.Component<>,
}