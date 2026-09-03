local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	ProductContainer = WorldPoint:component() :: jecs.Component<{ [string]: Types.Product }>,
}
