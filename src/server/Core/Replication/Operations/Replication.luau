local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local Signals = require("@ServerInternal/Signals")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Replicator = require("@SharedInternal/Replication/Replicator").server

local operations = {}

local function setupComponent(component: jecs.Id)
	WorldPoint:added(component, function(entity)
		WorldPoint:add(entity, jecs.pair(replecs.reliable :: jecs.Id, component))
	end)
end

local function startReplication()
	while task.wait(1 / 20) do
		for player, buf, variants in Replicator:collect_updates() do
			Signals.ReplicateGamestateChanges.Fire(player, buf, variants)
		end
	end
end

function operations.SetupComponentsReplication(instance: Instance, fileName: string)
	for _, module in pairs(instance:GetDescendants()) do
		if not module:IsA("ModuleScript") then continue end
		if module.Name:lower() ~= fileName:lower() then continue end
		local loaded = (require)(module) :: { [string]: jecs.Id }

		for _, component in pairs(loaded) do
			setupComponent(component)
		end
	end
end

function operations.SetupReplication()
	Replicator:init()

	Signals.RequestDataReplication.On(function(player, data)
		Replicator:mark_player_ready(player)
		Signals.ReplicateGamestate.Fire(player, Replicator:get_full(player))
	end)

	task.spawn(startReplication)
end

return operations
