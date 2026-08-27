local Types = require("@SharedGameplay/AbilityModule/Data/Types")

local abilities: { [string]: Types.Ability } = {}

for _, module in pairs(script.Parent.Abilities:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local data = (require)(module)
	abilities[data.Name] = data
end

return abilities
