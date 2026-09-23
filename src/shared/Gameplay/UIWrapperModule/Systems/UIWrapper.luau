--!strict
--[[
	Класс обёртки (OOP). Единственный класс модуля: тип поведения (события/эффекты)
	задаётся Options (Resources/WrapperOptions), а не наследованием.
	Только тонкие методы-делегаты в Operations/*.
]]

local WrapperConstructionOperations = require("../Operations/WrapperConstructionOperations")
local WrapperCallbacksOperations = require("../Operations/WrapperCallbacksOperations")
local WrapperPropertyCallbacksOperations = require("../Operations/WrapperPropertyCallbacksOperations")
local WrapperEffectsOperations = require("../Operations/WrapperEffectsOperations")
local IUIWrapper = require("../Data/IUIWrapper")
local Wrapper = require("../Data/Wrapper")
local WrapperState = require("../Data/WrapperState")
local Types = require("../Data/Types")

local UIWrapper = {}
UIWrapper.__index = UIWrapper

-- Единственный каст модуля: Luau не выводит методы класса из setmetatable для пересечения типов
function UIWrapper.new(
	instance: GuiObject,
	options: Types.Options,
	onDestroy: ((WrapperState.WrapperState) -> ())?
): Wrapper.Wrapper
	return setmetatable(WrapperConstructionOperations.Create(instance, options, onDestroy), UIWrapper) :: any
end

function UIWrapper.AddPropertyChangedCallback(
	self: Wrapper.Wrapper,
	property: string,
	id: string,
	cb: (value: any) -> ()
): string
	return WrapperPropertyCallbacksOperations.AddPropertyChangedCallback(self, property, id, cb)
end

function UIWrapper.RemovePropertyChangedCallback(self: Wrapper.Wrapper, property: string, id: string)
	WrapperPropertyCallbacksOperations.RemovePropertyChangedCallback(self, property, id)
end

function UIWrapper.AddCallback(self: Wrapper.Wrapper, event: Types.EventName, id: string, cb: Types.Callback): string
	return WrapperCallbacksOperations.AddCallback(self, event, id, cb)
end

function UIWrapper.RemoveCallback(self: Wrapper.Wrapper, event: Types.EventName, id: string)
	WrapperCallbacksOperations.RemoveCallback(self, event, id)
end

function UIWrapper.RemoveAllCallbacks(self: Wrapper.Wrapper)
	WrapperCallbacksOperations.RemoveAllCallbacks(self)
end

function UIWrapper.Fire(self: Wrapper.Wrapper, event: Types.EventName, ...: any)
	WrapperCallbacksOperations.Fire(self, event, ...)
end

function UIWrapper.ApplyEffect(self: Wrapper.Wrapper, names: { string })
	WrapperEffectsOperations.ApplyEffect(self, names)
end

function UIWrapper.EmitEffect(self: Wrapper.Wrapper, entries: { WrapperEffectsOperations.EffectEntry })
	WrapperEffectsOperations.EmitEffect(self, entries)
end

function UIWrapper.IsDestroyed(self: Wrapper.Wrapper): boolean
	return WrapperConstructionOperations.IsDestroyed(self)
end

function UIWrapper.Destroy(self: Wrapper.Wrapper)
	WrapperConstructionOperations.Destroy(self)
end

export type UIWrapper<I, E, N, Entry> = IUIWrapper.IUIWrapper<I, E, N, Entry>

return UIWrapper
