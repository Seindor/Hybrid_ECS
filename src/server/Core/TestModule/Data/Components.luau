local jecs = require("@RbxPackages/jecs")
local World = require("@SharedInternal/Dependencies/ECS/World").Resource

return {
	Test = World:component() :: jecs.Id<number>,
}
