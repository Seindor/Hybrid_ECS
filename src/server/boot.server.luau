local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")

local AppService = require("@SharedCore/App/Services/App")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local App = AppService.new()

App:RegisterBootFiles(script.Parent :: Instance)
App:RegisterBootFiles(ReplicatedStorage)

App:Init()

local Replication = require("@ServerCore/Replication/Operations/Replication")
local AttributeCalculationAPI = require("@SharedGameplay/AttributeModule/APIs/AttributeCalculationAPI")
local AttributeConstructionAPI = require("@SharedGameplay/AttributeModule/APIs/AttributeConstructionAPI")

Replication.SetupReplication()
Replication.SetupComponentsReplication(ReplicatedStorage.Gameplay, "components")

local AbilityAPI = require("./Gameplay/AbilityModule/APIs/AbilityAPI")
local ProfileStoreAPI = require("./Core/ProfileStore/APIs/ProfileStoreAPI")
local PassiveAPI = require("./Gameplay/PassiveModule/APIs/PassiveAPI")
local StoreAPI = require("./Gameplay/StoreModule/APIs/StoreAPI")

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

	AbilityAPI._setupContainer(entity)

	AttributeConstructionAPI.CreateAttribute(entity, {
		name = "Test",
		value = 3,
		calculatorName = "TestCalculator",
	})

	AttributeConstructionAPI.CreateAttribute(entity, {
		name = "Test2",
		value = 3,
		calculatorName = "TestCalculator2",
	})

	AttributeConstructionAPI.CreateModifier(entity, {
		tags = { "Add" },
		value = 10,
	})

	AttributeConstructionAPI.CreateModifier(entity, {
		tags = { "Add" },
		value = 20,
	})

	print(AttributeCalculationAPI.GetCalculatedContainerAttribute(entity, "Test"))

	StoreAPI.RequestPurchase({
		name = "PurchaseTest",
		sender = entity,
		reciever = entity,
	})

	PassiveAPI.AttachPassive(entity, {
		name = "TestPassive",
		additional = {},
	})

	--[[
	task.delay(2, function()
		AbilityAPI.CreateAbility({
			owner = entity,
			abilityName = "Test",
		})

		AbilityAPI.ReplicateAbility({
			owner = entity,
			abilityName = "Test",
			players = {
				[player] = true,
			},
		})

		task.wait(1)
		AbilityAPI.StartAbility(entity, "Test")
		task.wait(1)
		AbilityAPI.StartAbility(entity, "Test")

		task.wait(2)
		AbilityAPI.InterruptAbility(entity, "Test")
	end)
	]]
end)

Players.PlayerRemoving:Connect(function(player)
	ProfileStoreAPI.UnloadPlayer(player, playerStore[player])
end)
