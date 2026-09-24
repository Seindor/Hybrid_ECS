--!strict
--[[
	Собирает объект-фрейм (FrameWrapper<I>), который отдаёт API: данные + методы для ":".
	Без метатаблиц: методы - общие функции модуля, положенные в поля таблицы, поэтому объект
	строго соответствует типу Components.FrameWrapper без кастов.
]]

local Components = require("../../Data/Components")
local Types = require("../../Data/Types")
local FrameCallbacksSystem = require("../../Systems/FrameCallbacksSystem")
local FrameEffectsSystem = require("../../Systems/FrameEffectsSystem")
local CommonMethods = require("./CommonMethods")

type HasState = CommonMethods.HasState

local handle = {}

local function addCallback(self: HasState, event: Types.GUIFrameCallbackType, id: string, cb: Types.Callback): string
	return FrameCallbacksSystem.AddCallback(self._state, event, id, cb)
end

local function removeCallback(self: HasState, event: Types.GUIFrameCallbackType, id: string)
	FrameCallbacksSystem.RemoveCallback(self._state, event, id)
end

local function removeAllCallbacks(self: HasState)
	FrameCallbacksSystem.RemoveAllCallbacks(self._state)
end

local function fire(self: HasState, event: Types.GUIFrameCallbackType, ...: any)
	FrameCallbacksSystem.Fire(self._state, event, ...)
end

local function applyEffect(self: HasState, names: { Types.UIFrameEffectName })
	FrameEffectsSystem.ApplyEffect(self._state, names)
end

local function emitEffect(self: HasState, entries: { Types.UIFrameEffectEntry })
	FrameEffectsSystem.EmitEffect(self._state, entries)
end

function handle.Build<I>(instance: I & GuiObject, state: Components.WrapperState): Components.FrameWrapper<I>
	return {
		instance = instance,
		miscData = state.miscData,
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
