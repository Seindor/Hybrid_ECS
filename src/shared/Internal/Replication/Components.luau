local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local components = {
	TestComponent = WorldPoint:component() :: jecs.Id<{ Health: number }>,
	TestComponent2 = WorldPoint:component() :: jecs.Id<number>,

	Player = WorldPoint:component() :: jecs.Id<Player>,
	AbilityMap = WorldPoint:component() :: jecs.Id<string>,
}

for name, component in pairs(components :: { [string]: jecs.Id }) do
	WorldPoint:set(component, jecs.Name, name)
	WorldPoint:add(component, replecs.shared :: jecs.Id)
end

local tokens = {
	TestComponent = "TestComponent",
}

-- server

local compoent = {}
compoent.Name = tokens.TestComponent

-- client

local clientcompoent = {}
clientcompoent.Name = tokens.TestComponent

return components
