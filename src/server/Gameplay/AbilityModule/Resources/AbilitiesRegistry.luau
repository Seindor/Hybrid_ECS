local Types = require("../Data/Types")

local abilities: { [string]: Types.IAbility } = {}

for _, module in pairs(script.Parent.Abilities:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local data = (require)(module)
	abilities[data.Name] = data
end

return abilities
