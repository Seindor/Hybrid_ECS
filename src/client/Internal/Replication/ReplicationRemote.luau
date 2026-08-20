local Players = game:GetService("Players")
local World = require("@SharedInternal/Dependencies/ECS/World").Resource
local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local Components = require("@SharedInternal/Replication/Components")
local Remote = require("@SharedInternal/Replication/Remote")
local Replicator = require("./Replicator")

Replicator:init()

print("test?")

local testcontrols = World:component() :: jecs.Id<number>

local testEntity = World:entity()
World:set(testEntity, Components.Player, Players.LocalPlayer)

World:set(testEntity, testcontrols, 11)

World:set(Components.Player, replecs.custom_handler, function(player: Player)
	return testEntity
end)

local testAbility = World:entity()
--World:add(testAbility, Components.AbilityMap)

local abilities = {
	["Test"] = testAbility,
}

World:set(Components.AbilityMap, replecs.custom_handler, function(id: string)
	return abilities[id]
end)

Remote.OnClientInvoke = function(...)
	print("updates")
	Replicator:apply_updates(...)
end

print("test?1")

Replicator:after_replication(function()
	print("replicated")
end)

local buf, variants = Remote:InvokeServer()
print(buf)
Replicator:apply_full(buf, variants)

print("test?2")

task.spawn(function()
	while task.wait(1 / 10) do
		--print(World:get(testEntity, Components.TestComponent))
	end
end)

return {}
