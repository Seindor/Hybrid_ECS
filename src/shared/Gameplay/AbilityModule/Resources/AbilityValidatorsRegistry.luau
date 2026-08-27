local Types = require("@SharedGameplay/AbilityModule/Data/Types")

local abilities: { [string]: Types.AbilityValidators } = {}

for _, module in pairs(script.Parent.AbilityValidators:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local data = (require)(module)
	abilities[data.Name] = data
end

return abilities
