--!strict
--[[
	Общие для Button и Frame действия: уничтожить обёртку, проверить, очистить всё.
]]

local Components = require("../Data/Components")
local WrapperLifecycleOperations = require("../Operations/WrapperLifecycleOperations")
local WrapperRegistryOperations = require("../Operations/WrapperRegistryOperations")

local system = {}

function system.Destroy(wrapper: Components.WrapperState)
	WrapperLifecycleOperations.Destroy(wrapper)
end

function system.IsDestroyed(wrapper: Components.WrapperState): boolean
	return WrapperLifecycleOperations.IsDestroyed(wrapper)
end

function system.Clear()
	for _, wrapper in WrapperRegistryOperations.GetAllButtons() do
		WrapperLifecycleOperations.Destroy(wrapper._state)
	end
	for _, wrapper in WrapperRegistryOperations.GetAllFrames() do
		WrapperLifecycleOperations.Destroy(wrapper._state)
	end
	WrapperRegistryOperations.Clear()
end

return system
