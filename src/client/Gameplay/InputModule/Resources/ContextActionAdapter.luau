local ContextActionService = game:GetService("ContextActionService") :: ContextActionService

local Types = require("../Data/Types")

local actions: { [string]: boolean } = {}

local adapter = {}

function adapter.BindAction(
	actionName: string,
	callback: Types.InputCallback,
	createTouchButton: boolean,
	...: Enum.UserInputType | Enum.KeyCode
)
	ContextActionService:BindAction(actionName, callback, createTouchButton, ...)
	actions[actionName] = true
end

function adapter.UnbindAction(actionName: string)
	if not actions[actionName] then return end
	actions[actionName] = nil
	ContextActionService:UnbindAction(actionName)
end

function adapter.IsBound(actionName: string): boolean
	return actions[actionName] == true
end

return adapter
