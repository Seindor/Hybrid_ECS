local Signals = require("@ClientInternal/Signals")
local Replicator = require("@SharedInternal/Replication/Replicator").client

local operations = {}

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

return operations
