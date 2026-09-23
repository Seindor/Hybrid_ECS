--!strict
--[[
	AddPropertyChangedCallback("Visible", "id", function(value) end)
	(раньше нужно было писать "VisibleChanged" - суффикс обрезался вручную)

	value: any - осознанно: тип зависит от имени свойства, которое известно только в рантайме.
]]

local WrapperState = require("../Data/WrapperState")

type State = WrapperState.WrapperState

local operations = {}

local PROPERTY_KEY = "Property:"

function operations.AddPropertyChangedCallback(
	self: State,
	property: string,
	id: string,
	cb: (value: any) -> ()
): string
	if self._destroyed then return id end

	local instance = self.instance
	self._janitor:Add(
		instance:GetPropertyChangedSignal(property):Connect(function()
			cb((instance :: any)[property])
		end),
		"Disconnect",
		`{PROPERTY_KEY}{property}:{id}`
	)

	return id
end

function operations.RemovePropertyChangedCallback(self: State, property: string, id: string)
	if self._destroyed then return end
	self._janitor:Remove(`{PROPERTY_KEY}{property}:{id}`)
end

return operations
