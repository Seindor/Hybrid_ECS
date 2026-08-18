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

function BootstrapperService.Launch(roots: { Instance }, ...: string)
	local moduleNames = { ... }

	local nameSet: { [string]: boolean }? = nil

	if #moduleNames > 0 then
		nameSet = {}
		for _, name in moduleNames do
			nameSet[name] = true
		end
	end

	for _, root in roots do
		if not root then continue end
		for _, instance in root:GetDescendants() do
			if not instance:IsA("ModuleScript") then continue end

			if table.find(Modules, instance) then continue end

			if nameSet and not nameSet[instance.Name] then continue end

			local mod = safeRequire(instance)

			if mod and mod.Init then
				table.insert(Modules, instance)
				mod.Init()
			end
		end
	end
end

return BootstrapperService
