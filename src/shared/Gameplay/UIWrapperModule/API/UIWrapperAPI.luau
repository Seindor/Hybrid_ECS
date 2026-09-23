--!strict
--[[
	Публичная точка входа и одновременно "boot": в ECS-пакете boot регистрирует системы
	в App, тут планировщика нет, поэтому new() создаёт реестр и связывает с ним Systems.

	local api = UIWrapperAPI.new()

	local btn = api:CreateButton(screenGui.PlayButton)  -- IUIButtonWrapper<TextButton>
	btn:EmitEffect({ { name = "SpringEffect", params = { duration = 0.5 } } })

	local win = api:CreateFrame(screenGui.Window)       -- IUIFrameWrapper<Frame>

	Внутри реестр хранит Wrapper (внутренний тип), наружу отдаются IUIButtonWrapper/IUIFrameWrapper:
	каст :: any стоит только на этой границе.
]]

local IUIWrapper = require("../Data/IUIWrapper")
local Registry = require("../Data/Registry")
local Wrapper = require("../Data/Wrapper")
local WrapperRegistryOperations = require("../Operations/WrapperRegistryOperations")
local WrapperCanvasSystem = require("../Systems/WrapperCanvasSystem")
local WrapperLifecycleSystem = require("../Systems/WrapperLifecycleSystem")

local UIWrapperAPI = {}
UIWrapperAPI.__index = UIWrapperAPI

type Impl = typeof(setmetatable({} :: { registry: Registry.Registry }, UIWrapperAPI))

function UIWrapperAPI.new(): Impl
	return setmetatable({ registry = Registry.New() }, UIWrapperAPI)
end

-- Тип обёртки (кнопка/фрейм) выбирается по классу инстанса в рантайме, статически его не выразить -
-- если нужен конкретный тип, используй CreateButton / CreateFrame.
function UIWrapperAPI.Create(self: Impl, instance: GuiObject): any
	return WrapperLifecycleSystem.Create(self.registry, instance)
end

function UIWrapperAPI.CreateButton<I>(self: Impl, instance: I & GuiButton): IUIWrapper.IUIButtonWrapper<I>
	return WrapperLifecycleSystem.Create(self.registry, instance) :: any
end

function UIWrapperAPI.CreateFrame<I>(self: Impl, instance: I & GuiObject): IUIWrapper.IUIFrameWrapper<I>
	return WrapperLifecycleSystem.Create(self.registry, instance) :: any
end

function UIWrapperAPI.Get(self: Impl, instance: GuiObject): Wrapper.Wrapper?
	return WrapperRegistryOperations.Get(self.registry, instance)
end

function UIWrapperAPI.GetButton<I>(self: Impl, instance: I & GuiButton): IUIWrapper.IUIButtonWrapper<I>?
	return WrapperRegistryOperations.Get(self.registry, instance) :: any
end

function UIWrapperAPI.GetFrame<I>(self: Impl, instance: I & GuiObject): IUIWrapper.IUIFrameWrapper<I>?
	return WrapperRegistryOperations.Get(self.registry, instance) :: any
end

function UIWrapperAPI.Remove(self: Impl, instance: GuiObject, destroyInstance: boolean?)
	WrapperLifecycleSystem.Remove(self.registry, instance, destroyInstance)
end

function UIWrapperAPI.GetAll(self: Impl): { Wrapper.Wrapper }
	return WrapperRegistryOperations.GetAll(self.registry)
end

function UIWrapperAPI.Clear(self: Impl)
	WrapperLifecycleSystem.Clear(self.registry)
end

function UIWrapperAPI.FixCanvas(self: Impl, scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?)
	WrapperCanvasSystem.FixCanvas(self.registry, scrollingFrame, axis)
end

return UIWrapperAPI
