--!strict
--[[
	Создание / получение / удаление кнопки. Аналог AbilityCreation: склеивает операции
	(сборка данных, подписка на Destroying, объект с методами, реестр).
]]

local Components = require("../Data/Components")
local WrapperConstructionOperations = require("../Operations/WrapperConstructionOperations")
local WrapperLifecycleOperations = require("../Operations/WrapperLifecycleOperations")
local WrapperRegistryOperations = require("../Operations/WrapperRegistryOperations")
local ButtonHandle = require("../Resources/Handles/ButtonHandle")
local ButtonOptions = require("../Resources/WrapperOptions/Button")

local system = {}

function system.Create<I>(instance: I & GuiButton): Components.ButtonWrapper<I>
	local existing = WrapperRegistryOperations.GetButton(instance)
	if existing then return existing end

	local state = WrapperConstructionOperations.Create(instance, ButtonOptions, function()
		WrapperRegistryOperations.PopButton(instance)
	end)
	WrapperLifecycleOperations.BindDestroying(state)

	local wrapper = ButtonHandle.Build(instance, state)
	WrapperRegistryOperations.AddButton(instance, wrapper)

	return wrapper
end

function system.Get<I>(instance: I & GuiButton): Components.ButtonWrapper<I>?
	return WrapperRegistryOperations.GetButton(instance)
end

function system.Remove(instance: GuiButton, destroyInstance: boolean?)
	local wrapper = WrapperRegistryOperations.GetButton(instance)
	if not wrapper then return end

	WrapperLifecycleOperations.Destroy(wrapper._state) -- через onDestroy сам уберётся из реестра
	if destroyInstance then instance:Destroy() end
end

return system
