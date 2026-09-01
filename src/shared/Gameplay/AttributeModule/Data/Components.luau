local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	AttributesContainer = WorldPoint:component() :: jecs.Component<{ [string]: Types.Attribute }>,
	ModifiersContainer = WorldPoint:component() :: jecs.Component<{ [string]: Types.Modifier }>,
}
