local Signals = require("@ClientInternal/Signals")
local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Replicator = require("@SharedInternal/Replication/Replicator").client

local operations = {}

local function setupComponent(name: string, component: jecs.Id)
	WorldPoint:add(component, replecs.shared)
	WorldPoint:set(component, jecs.Name, name)
end

function operations.SetupReplication()
	Replicator:init()

	Signals.ReplicateGamestateChanges.On(function(...)
		Replicator:apply_updates(...)
	end)

	Signals.ReplicateGamestate.On(function(...)
		Replicator:apply_full(...)
	end)

	Signals.RequestDataReplication.Fire()
end

function operations.SetupComponentsReplication(instance: Instance, fileName: string)
	for _, module in pairs(instance:GetDescendants()) do
		if not module:IsA("ModuleScript") then continue end
		if module.Name:lower() ~= fileName:lower() then continue end
		local loaded = (require)(module) :: { [string]: jecs.Id }

		for name, component in pairs(loaded) do
			setupComponent(name, component)
		end
	end
end

return operations
