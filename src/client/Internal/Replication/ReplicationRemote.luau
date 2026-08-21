local Players = game:GetService("Players")
local World = require("@SharedInternal/Dependencies/ECS/World").Resource
local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local Components = require("@SharedInternal/Replication/Components")

task.spawn(function()
	while task.wait(1 / 10) do
		for entity, data in World:query(Components.TestComponent) do
			print(data)
		end
	end
end)

return {}
