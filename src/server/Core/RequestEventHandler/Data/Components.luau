local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Request = WorldPoint:component() :: jecs.Component<>,
	Event = WorldPoint:component() :: jecs.Component<>,
}
