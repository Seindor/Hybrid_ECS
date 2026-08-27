local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replication = require("@ClientCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")
local Components = require("@SharedGameplay/AbilityModule/Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local App = AppService.new()

Replication.SetupReplication()
Replication.SetupComponentsReplication(ReplicatedStorage.Gameplay, "components")

App:Init()

task.spawn(function()
	print("setup")
	while task.wait(1 / 10) do
		for entity, data in WorldPoint:query(Components.State) do
			print(`Current server ability state: {data}`)
		end
	end
end)
