--!strict

local Container = require("./Container")
type ContainerObject = Container.ContainerObject

local RegisterDependencies = {}

function RegisterDependencies.register(container: ContainerObject, folder: Instance)
	for _, moduleInstance in folder:GetDescendants() do
		if not moduleInstance:IsA("ModuleScript") then continue end

		local requireSucceeded, requiredModule = pcall(require, moduleInstance)
		if not requireSucceeded then
			warn(`DI: cannot require {moduleInstance:GetFullName()}: {requiredModule}`)
			continue
		end

		if typeof(requiredModule) ~= "table" then continue end

		local providerModule = requiredModule :: { register: ((container: ContainerObject) -> ())? }
		if providerModule.register then providerModule.register(container) end
	end
end

return RegisterDependencies
