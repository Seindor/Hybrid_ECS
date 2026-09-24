--!strict
--[[
	AddPropertyChangedCallback("Visible", "id", function(value) end)
	(раньше нужно было писать "VisibleChanged" - суффикс обрезался вручную)

	value: any - осознанно: тип зависит от имени свойства, которое известно только в рантайме.
]]

local Components = require("../Data/Components")

type State = Components.WrapperState

local operations = {}

local PROPERTY_KEY = "Property:"

function operations.AddPropertyChangedCallback(
	wrapper: State,
	property: string,
	id: string,
	cb: (value: any) -> ()
): string
	if wrapper._destroyed then return id end

	local instance = wrapper.instance
	wrapper._janitor:Add(
		instance:GetPropertyChangedSignal(property):Connect(function()
			cb((instance :: any)[property])
		end),
		"Disconnect",
		`{PROPERTY_KEY}{property}:{id}`
	)

	return id
end

function operations.RemovePropertyChangedCallback(wrapper: State, property: string, id: string)
	if wrapper._destroyed then return end
	wrapper._janitor:Remove(`{PROPERTY_KEY}{property}:{id}`)
end

return operations
