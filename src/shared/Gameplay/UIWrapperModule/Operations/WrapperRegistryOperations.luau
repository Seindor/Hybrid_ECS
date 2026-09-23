--!strict
--[[
	Операции над реестром. Аналог QuestsContainerOperations.
]]

local Registry = require("../Data/Registry")
local Wrapper = require("../Data/Wrapper")

local operations = {}

function operations.Add(registry: Registry.Registry, instance: GuiObject, wrapper: Wrapper.Wrapper)
	registry.wrappers[instance] = wrapper
end

function operations.Get(registry: Registry.Registry, instance: GuiObject): Wrapper.Wrapper?
	return registry.wrappers[instance]
end

function operations.Pop(registry: Registry.Registry, instance: GuiObject): Wrapper.Wrapper?
	local wrapper = registry.wrappers[instance]
	registry.wrappers[instance] = nil
	return wrapper
end

function operations.GetAll(registry: Registry.Registry): { Wrapper.Wrapper }
	local result = {}
	for _, wrapper in registry.wrappers do
		table.insert(result, wrapper)
	end
	return result
end

function operations.Clear(registry: Registry.Registry)
	table.clear(registry.wrappers)
end

return operations
