local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local Replication = require("@ServerCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")
local Tokens = require("@SharedInternal/Dependencies/Tokens")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local App = AppService.new()

Replication.SetupReplication()
Replication.SetupComponentsReplication(ReplicatedStorage.Internal, "components")

App:RegisterResource(Tokens.ECS.World, WorldPoint)
App:RegisterResource(Tokens.ECS.RuntimePriorities, RuntimePriorities)

App:RegisterBootFiles(script.Parent :: Instance)

App:Init()

local Components = require("@SharedInternal/Replication/Components")
local ProfileStoreAPI = require("./Core/ProfileStore/APIs/ProfileStoreAPI")

local playerStore = {}
local playerComponent = WorldPoint:component() :: jecs.Id<Player>

Players.PlayerAdded:Connect(function(player)
	local entity = WorldPoint:entity()
	playerStore[player] = entity
	WorldPoint:set(entity, playerComponent, player)
	WorldPoint:set(entity, replecs.networked, {
		[player] = true,
	})
	ProfileStoreAPI.LoadPlayer(player, entity)
end)

Players.PlayerRemoving:Connect(function(player)
	ProfileStoreAPI.UnloadPlayer(player, playerStore[player])
end)

task.spawn(function()
	while task.wait(1 / 10) do
		for entity, player, data in WorldPoint:query(playerComponent, Components.TestComponent) do
			local character = player.Character
			if not character then continue end

			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			if not humanoid then continue end

			local health = humanoid.Health
			data.Health = health

			WorldPoint:set(entity, Components.TestComponent, data)
		end
	end
end)
