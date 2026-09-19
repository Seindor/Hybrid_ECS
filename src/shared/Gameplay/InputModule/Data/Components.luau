local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Inputs = WorldPoint:component() :: jecs.Component<Types.InputSnapshot>,
}
