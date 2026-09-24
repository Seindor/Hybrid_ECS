--!strict
--[[
	Методы, общие для ButtonWrapper и FrameWrapper. self - структурный ({ _state }),
	поэтому одни и те же функции подходят любому ButtonWrapper<I> / FrameWrapper<I>.
	Логики тут нет: каждый метод - вызов Systems.
]]

local Components = require("../../Data/Components")
local WrapperLifecycleSystem = require("../../Systems/WrapperLifecycleSystem")
local WrapperPropertyCallbacksSystem = require("../../Systems/WrapperPropertyCallbacksSystem")

export type HasState = { _state: Components.WrapperState }

local methods = {}

function methods.AddPropertyChangedCallback(self: HasState, property: string, id: string, cb: (value: any) -> ()): string
	return WrapperPropertyCallbacksSystem.AddPropertyChangedCallback(self._state, property, id, cb)
end

function methods.RemovePropertyChangedCallback(self: HasState, property: string, id: string)
	WrapperPropertyCallbacksSystem.RemovePropertyChangedCallback(self._state, property, id)
end

function methods.IsDestroyed(self: HasState): boolean
	return WrapperLifecycleSystem.IsDestroyed(self._state)
end

function methods.Destroy(self: HasState)
	WrapperLifecycleSystem.Destroy(self._state)
end

return methods
