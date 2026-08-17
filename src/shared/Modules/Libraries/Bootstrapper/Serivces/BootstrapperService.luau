local BootstrapperService = {}

local Modules = {}

type BootstrapModule = {
	Init: () -> (),
}

local function safeRequire(instance: ModuleScript): BootstrapModule?
	local success, result = pcall(require, instance)

	if not success then
		warn(`[Bootstrapper] Cannot require {instance:GetFullName()}: {tostring(result)}`)
		return nil
	end

	if type(result) ~= "table" then return nil end

	if type(result.Init) ~= "function" then return nil end

	return result :: BootstrapModule
end

function BootstrapperService.Launch(roots: { Instance }, moduleName: string?)
	for _, root in roots do
		for _, instance in root:GetDescendants() do
			if not instance:IsA("ModuleScript") then continue end

			if table.find(Modules, instance) then continue end

			if moduleName and instance.Name ~= moduleName then continue end

			local mod = safeRequire(instance)

			if mod and mod.Init then
				table.insert(Modules, instance)
				mod.Init()
			end
		end
	end
end

return BootstrapperService
