local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replication = require("@ClientCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")
local _Components = require("@SharedGameplay/AbilityModule/Data/Components")
local _WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local App = AppService.new()

Replication.SetupReplication()
Replication.SetupComponentsReplication(ReplicatedStorage.Gameplay, "components")

App:RegisterBootFiles(script.Parent)
App:RegisterBootFiles(ReplicatedStorage)

App:Init()
