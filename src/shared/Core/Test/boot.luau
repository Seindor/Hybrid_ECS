local App = require("@SharedCore/App/Services/App")
local Adapter = require("@SharedCore/Test/Services/Adapter")
local TestService2 = require("@SharedCore/Test/Services/TestService2")
local TestSystem = require("@SharedCore/Test/Services/TestSystem")
local Tokens = require("@SharedInternal/Dependencies/Tokens")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")

return function(app: App.IApp)
	app:RegisterResource(Tokens.ECS.RuntimePriorities, RuntimePriorities)
	app:RegisterResource(Tokens.Test.Test, TestService2)
	app:RegisterResource(Tokens.Test.Adapter, Adapter.new())

	app:RegisterSystem(TestSystem.Test, RuntimePriorities.Groups.Combat, RuntimePriorities.Priorities.Combat.Damage)
end
