local Types = require("../Data/Types")
local InputBehaviors = require("@ClientInternal/Dependencies/Registries/InputBehaviors")
local ContextActionAdapter = require("../Resources/ContextActionAdapter")

local operations = {}

function operations.BindInput(data: Types.BindInputRequestData)
	if ContextActionAdapter.IsBound(data.actionName) then return end

	local behavior = InputBehaviors.Resource[data.actionName]
	if not behavior then return end

	ContextActionAdapter.BindAction(
		data.actionName,
		behavior.Handle,
		data.createTouchButton or false,
		unpack(data.inputTypes)
	)
end

function operations.UnbindInput(data: Types.UnbindInputRequestData)
	ContextActionAdapter.UnbindAction(data.actionName)
end

function operations.IsBound(actionName: string): boolean
	return ContextActionAdapter.IsBound(actionName)
end

return operations
