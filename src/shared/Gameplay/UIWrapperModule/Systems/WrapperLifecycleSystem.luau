--!strict
--[[
	Создать / убрать / очистить обёртки. Аналог QuestsCreationSystem:
	склеивает Construction и Registry операции.
	Тип (Button/Frame) выбирается по instance:IsA("GuiButton").
]]

local Registry = require("../Data/Registry")
local Wrapper = require("../Data/Wrapper")
local WrapperRegistryOperations = require("../Operations/WrapperRegistryOperations")
local ButtonOptions = require("../Resources/WrapperOptions/Button")
local FrameOptions = require("../Resources/WrapperOptions/Frame")
local UIWrapper = require("./UIWrapper")

local system = {}

function system.Create(registry: Registry.Registry, instance: GuiObject): Wrapper.Wrapper
	local existing = WrapperRegistryOperations.Get(registry, instance)
	if existing then return existing end

	local options = if instance:IsA("GuiButton") then ButtonOptions else FrameOptions

	local wrapper = UIWrapper.new(instance, options, function()
		WrapperRegistryOperations.Pop(registry, instance)
	end)

	WrapperRegistryOperations.Add(registry, instance, wrapper)
	return wrapper
end

function system.Remove(registry: Registry.Registry, instance: GuiObject, destroyInstance: boolean?)
	local wrapper = WrapperRegistryOperations.Get(registry, instance)
	if not wrapper then return end

	wrapper:Destroy() -- через onDestroy сам уберётся из реестра
	if destroyInstance then instance:Destroy() end
end

function system.Clear(registry: Registry.Registry)
	for _, wrapper in WrapperRegistryOperations.GetAll(registry) do
		wrapper:Destroy()
	end
	WrapperRegistryOperations.Clear(registry)
end

return system
