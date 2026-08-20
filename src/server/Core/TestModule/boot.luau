local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/Dependencies/ECS/RuntimePriorities").Resource

local System = require("./Systems/TestSystem")

return function(app: App.IApp)
	app:RegisterSystem(System.TestTick, RuntimePriorities.Groups.Combat, RuntimePriorities.Priorities.Combat.Damage)
	--[[
	task.delay(2, function()
		TestOperations.Test(2)
	end)
    ]]
end
