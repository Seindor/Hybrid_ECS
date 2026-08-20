local Players = game:GetService("Players")
local World = require("@SharedInternal/Dependencies/ECS/World").Resource
local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local Components = require("@SharedInternal/Replication/Components")
local Remote = require("@SharedInternal/Replication/Remote")
local Replicator = require("./Replicator")

Replicator:init()

print("loaded")

Remote.OnServerInvoke = function(player: Player)
	print("tag1")
	Replicator:mark_player_ready(player)
	return Replicator:get_full(player)
end

task.spawn(function()
	while task.wait(1 / 20) do
		for player, buf, variants in Replicator:collect_updates() do
			Remote:InvokeClient(player, buf, variants)
		end
	end
end)

local playerComponent = World:component() :: jecs.Id<Player>

local ability = World:entity()
World:set(ability, replecs.networked :: jecs.Id)
World:set(ability, Components.TestComponent2, 120)
World:set(ability, Components.AbilityMap, "Test")

Replicator:set_custom(ability, Components.AbilityMap)

World:add(ability, jecs.pair(replecs.reliable :: jecs.Id, Components.TestComponent2))
World:add(ability, jecs.pair(replecs.reliable :: jecs.Id, Components.AbilityMap))

local stored = Components.TestComponent

World:added(stored, function(entity: jecs.Id, id: jecs.Id, value)
	World:add(entity, jecs.pair(replecs.reliable :: jecs.Id, stored))
end)

local function create(player: Player)
	local entity = World:entity()
	World:set(entity, replecs.networked :: jecs.Id, {
		[player] = true,
	})

	World:set(entity, Components.TestComponent, { Health = 100 })
	World:set(entity, playerComponent, player)

	return entity
end

Players.PlayerAdded:Connect(function(player)
	local entity = create(player)

	World:set(entity, Components.Player, player)
	Replicator:set_custom(entity, Components.Player)
	World:add(entity, jecs.pair(replecs.reliable :: jecs.Id, Components.Player))
end)

task.spawn(function()
	while task.wait(1 / 10) do
		for entity, player, data in World:query(playerComponent, Components.TestComponent) do
			local character = player.Character
			if not character then continue end

			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			if not humanoid then continue end

			local health = humanoid.Health
			data.Health = health

			World:set(entity, Components.TestComponent, data)
		end
	end
end)

return {}
