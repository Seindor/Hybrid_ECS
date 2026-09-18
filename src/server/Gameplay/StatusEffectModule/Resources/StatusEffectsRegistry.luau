local Interfaces = require("@SharedGameplay/StatusEffectModule/Data/Interfaces")

local registry: { [string]: Interfaces.IStatusEffectObject } = {}

for _, module in pairs(script.Parent.StatusEffects:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	registry[module.Name] = (require)(module)
end

return registry