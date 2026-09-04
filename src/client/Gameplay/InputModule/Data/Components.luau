local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	BindInputRequestData = WorldPoint:component() :: jecs.Component<Types.BindInputRequestData>,
	UnbindInputRequestData = WorldPoint:component() :: jecs.Component<Types.UnbindInputRequestData>,
}