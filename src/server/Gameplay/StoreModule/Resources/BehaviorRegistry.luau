local Types = require("../Data/Types")

local registry: { [string]: Types.IBehavior } = {}

for _, module in pairs(script.Parent.Behaviors:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local data = (require)(module)
	registry[module.Name] = data
end

return registry
