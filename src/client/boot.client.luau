local Replication = require("@ClientCore/Replication/Operations/Replication")
local AppService = require("@SharedCore/App/Services/App")

local App = AppService.new()

Replication.SetupReplication()

App:Init()
