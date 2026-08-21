local Replication = require("@ClientCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")
local Tokens = require("@SharedInternal/Dependencies/Tokens")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local App = AppService.new()

Replication.SetupReplication()

App:RegisterResource(Tokens.ECS.World, WorldPoint)
App:RegisterResource(Tokens.ECS.RuntimePriorities, RuntimePriorities)

App:Init()

local ReplicationRemote = require("@ClientInternal/Replication/ReplicationRemote")
