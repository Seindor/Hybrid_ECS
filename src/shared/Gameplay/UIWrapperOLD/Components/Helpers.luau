--!strict

local Helpers = {}

--[[
	Ищет UIScale: сначала прямой ребёнок, потом среди потомков.
	Не yield'ит (раньше в Frame-эффектах был WaitForChild).
	Если не нашёл - warn и nil, эффект должен просто выйти.
]]
function Helpers.FindUIScale(instance: Instance, effectName: string): UIScale?
	local found = instance:FindFirstChildWhichIsA("UIScale") or instance:FindFirstChildWhichIsA("UIScale", true)

	if not found then
		warn(`[UIWrapper] {effectName}: UIScale не найден в {instance:GetFullName()}`)
	end

	return found :: UIScale?
end

return Helpers
