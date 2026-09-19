local jecs = require("@RbxPackages/jecs")
local SharedComponents = require("@SharedGameplay/InputModule/Data/Components")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Shared = SharedComponents,

	BindInputRequestData = WorldPoint:component() :: jecs.Component<Types.BindInputRequestData>,
	UnbindInputRequestData = WorldPoint:component() :: jecs.Component<Types.UnbindInputRequestData>,
}