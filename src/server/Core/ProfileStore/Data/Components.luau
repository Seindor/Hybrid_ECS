local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	ProfileConversion = WorldPoint:component() :: jecs.Id<{ id: string, player: Player }>,
}
