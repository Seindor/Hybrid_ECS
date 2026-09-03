local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	PassiveContainer = WorldPoint:component() :: jecs.Component<{ [string]: Types.Passive }>,
}
