local jecs = require("@RbxPackages/jecs")
local replecs = require("@RbxPackages/replecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

local function setupComponent(component: jecs.Id)
	WorldPoint:added(component, function(entity)
		WorldPoint:add(entity, jecs.pair(replecs.reliable :: jecs.Id, component))
	end)
end

function operations.SetupComponentsReplication(instance: Instance, fileName: string)
	for _, module in pairs(instance:GetDescendants()) do
		if not module:IsA("ModuleScript") then continue end
		if module.Name ~= fileName then continue end
		local loaded = (require)(module) :: { [string]: jecs.Id }

		for _, component in pairs(loaded) do
			setupComponent(component)
		end
	end
end

return operations
