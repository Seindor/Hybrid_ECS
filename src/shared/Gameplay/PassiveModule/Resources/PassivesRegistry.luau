local Types = require("../Data/Types")

local registry: { [string]: Types.IPassiveObject } = {}

for _, module in pairs(script.Parent.Calculators:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local data = (require)(module)
	registry[module.Name] = data
end

return registry
