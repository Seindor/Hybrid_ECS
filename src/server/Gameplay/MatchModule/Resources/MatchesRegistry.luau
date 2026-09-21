local Types = require("@SharedGameplay/MatchModule/Data/Types")

local matches: { [string]: Types.Match } = {}

for _, module in pairs(script.Parent.Matches:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local data = (require)(module)
	matches[data.Name] = data
end

return matches
