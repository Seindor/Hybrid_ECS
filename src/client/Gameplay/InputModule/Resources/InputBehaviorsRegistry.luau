local Types = require("../Data/Types")

local registry: { [string]: Types.IInputBehavior } = {}

for _, module in pairs(script.Parent.InputBehaviors:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	registry[module.Name] = (require)(module)
end

return registry