local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local Replication = require("@ServerCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local App = AppService.new()

Replication.SetupReplication()
Replication.SetupComponentsReplication(ReplicatedStorage.Internal, "components")

App:RegisterBootFiles(script.Parent :: Instance)

App:Init()

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
