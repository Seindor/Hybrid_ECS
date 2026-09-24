--!strict
--[[
	AddPropertyChangedCallback(wrapper, "Visible", "id", function(value) end)
	Общий для кнопок и фреймов.
]]

local Components = require("../Data/Components")
local WrapperPropertyCallbacksOperations = require("../Operations/WrapperPropertyCallbacksOperations")

local system = {}

function system.AddPropertyChangedCallback(
	wrapper: Components.WrapperState,
	property: string,
	id: string,
	cb: (value: any) -> ()
): string
	return WrapperPropertyCallbacksOperations.AddPropertyChangedCallback(wrapper, property, id, cb)
end

function system.RemovePropertyChangedCallback(wrapper: Components.WrapperState, property: string, id: string)
	WrapperPropertyCallbacksOperations.RemovePropertyChangedCallback(wrapper, property, id)
end

return system
