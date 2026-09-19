local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replication = require("@ClientCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")
local _Components = require("@SharedGameplay/AbilityModule/Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local InputAPI = require("@ClientGameplay/InputModule/APIs/InputAPI")
local InputComponents = require("@ClientGameplay/InputModule/Data/Components")
local InputTypes = require("@ClientGameplay/InputModule/Data/Types")

local App = AppService.new()

Replication.SetupReplication()
Replication.SetupComponentsReplication(ReplicatedStorage.Gameplay, "components")

App:RegisterBootFiles(script.Parent)
App:RegisterBootFiles(ReplicatedStorage)

App:Init()

local function setupInput()
	local player = Players.LocalPlayer
	if not player then
		Players:GetPropertyChangedSignal("LocalPlayer"):Once(setupInput)
		return
	end

	local entity = WorldPoint:entity()
	WorldPoint:set(entity, InputComponents.Shared.Inputs, {} :: InputTypes.InputSnapshot)
	InputAPI.BindInput({
		owner = entity,
		actionName = "Test",
		inputTypes = { Enum.KeyCode.Q },
	})
end

setupInput()