local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	TimerContainer = WorldPoint:component() :: jecs.Component<Types.TimerContainer>,
}
