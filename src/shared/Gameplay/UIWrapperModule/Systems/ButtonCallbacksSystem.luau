--!strict
--[[
	Колбэки на события кнопки. Список событий ограничен GUIButtonCallbackType.
]]

local Components = require("../Data/Components")
local Types = require("../Data/Types")
local WrapperCallbacksOperations = require("../Operations/WrapperCallbacksOperations")

local system = {}

function system.AddCallback(
	wrapper: Components.WrapperState,
	event: Types.GUIButtonCallbackType,
	id: string,
	cb: Types.Callback
): string
	return WrapperCallbacksOperations.AddCallback(wrapper, event, id, cb)
end

function system.RemoveCallback(wrapper: Components.WrapperState, event: Types.GUIButtonCallbackType, id: string)
	WrapperCallbacksOperations.RemoveCallback(wrapper, event, id)
end

function system.RemoveAllCallbacks(wrapper: Components.WrapperState)
	WrapperCallbacksOperations.RemoveAllCallbacks(wrapper)
end

function system.Fire(wrapper: Components.WrapperState, event: Types.GUIButtonCallbackType, ...: any)
	WrapperCallbacksOperations.Fire(wrapper, event, ...)
end

return system
