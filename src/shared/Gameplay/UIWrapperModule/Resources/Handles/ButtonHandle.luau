--!strict
--[[
	Собирает объект-кнопку (ButtonWrapper<I>), который отдаёт API: данные + методы для ":".
	Без метатаблиц: методы - общие функции модуля, положенные в поля таблицы, поэтому объект
	строго соответствует типу Components.ButtonWrapper без кастов.
]]

local Components = require("../../Data/Components")
local Types = require("../../Data/Types")
local ButtonCallbacksSystem = require("../../Systems/ButtonCallbacksSystem")
local ButtonEffectsSystem = require("../../Systems/ButtonEffectsSystem")
local CommonMethods = require("./CommonMethods")

type HasState = CommonMethods.HasState

local handle = {}

local function addCallback(self: HasState, event: Types.GUIButtonCallbackType, id: string, cb: Types.Callback): string
	return ButtonCallbacksSystem.AddCallback(self._state, event, id, cb)
end

local function removeCallback(self: HasState, event: Types.GUIButtonCallbackType, id: string)
	ButtonCallbacksSystem.RemoveCallback(self._state, event, id)
end

local function removeAllCallbacks(self: HasState)
	ButtonCallbacksSystem.RemoveAllCallbacks(self._state)
end

local function fire(self: HasState, event: Types.GUIButtonCallbackType, ...: any)
	ButtonCallbacksSystem.Fire(self._state, event, ...)
end

local function applyEffect(self: HasState, names: { Types.UIButtonEffectName })
	ButtonEffectsSystem.ApplyEffect(self._state, names)
end

local function emitEffect(self: HasState, entries: { Types.UIButtonEffectEntry })
	ButtonEffectsSystem.EmitEffect(self._state, entries)
end

function handle.Build<I>(instance: I & GuiButton, state: Components.WrapperState): Components.ButtonWrapper<I>
	return {
		instance = instance,
		miscData = state.miscData,
		_janitor = state._janitor,
		_state = state,

		AddCallback = addCallback,
		RemoveCallback = removeCallback,
		RemoveAllCallbacks = removeAllCallbacks,
		Fire = fire,

		AddPropertyChangedCallback = CommonMethods.AddPropertyChangedCallback,
		RemovePropertyChangedCallback = CommonMethods.RemovePropertyChangedCallback,

		ApplyEffect = applyEffect,
		EmitEffect = emitEffect,

		IsDestroyed = CommonMethods.IsDestroyed,
		Destroy = CommonMethods.Destroy,
	}
end

return handle
