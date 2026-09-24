--!strict
--[[
	Создание / получение / удаление фрейма (Frame, ScrollingFrame, TextLabel и любой другой GuiObject). Аналог AbilityCreation: склеивает операции
	(сборка данных, подписка на Destroying, объект с методами, реестр).
]]

local Components = require("../Data/Components")
local WrapperConstructionOperations = require("../Operations/WrapperConstructionOperations")
local WrapperLifecycleOperations = require("../Operations/WrapperLifecycleOperations")
local WrapperRegistryOperations = require("../Operations/WrapperRegistryOperations")
local FrameHandle = require("../Resources/Handles/FrameHandle")
local FrameOptions = require("../Resources/WrapperOptions/Frame")

local system = {}

function system.Create<I>(instance: I & GuiObject): Components.FrameWrapper<I>
	local existing = WrapperRegistryOperations.GetFrame(instance)
	if existing then return existing end

	local state = WrapperConstructionOperations.Create(instance, FrameOptions, function()
		WrapperRegistryOperations.PopFrame(instance)
	end)
	WrapperLifecycleOperations.BindDestroying(state)

	local wrapper = FrameHandle.Build(instance, state)
	WrapperRegistryOperations.AddFrame(instance, wrapper)

	return wrapper
end

function system.Get<I>(instance: I & GuiObject): Components.FrameWrapper<I>?
	return WrapperRegistryOperations.GetFrame(instance)
end

function system.Remove(instance: GuiObject, destroyInstance: boolean?)
	local wrapper = WrapperRegistryOperations.GetFrame(instance)
	if not wrapper then return end

	WrapperLifecycleOperations.Destroy(wrapper._state) -- через onDestroy сам уберётся из реестра
	if destroyInstance then instance:Destroy() end
end

return system
