local jecs = require("@RbxPackages/jecs")
local Types = require("../Data/Types")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local ContextActionAdapter = require("../Resources/ContextActionAdapter")

local operations = {}

local function GetInputKey(inputObject: InputObject): string
	if inputObject.KeyCode == Enum.KeyCode.None then return inputObject.UserInputType.Name end
	return inputObject.KeyCode.Name
end

function operations.LogInput(owner: jecs.Entity, inputObject: InputObject, inputState: Enum.UserInputState)
	local inputs = WorldPoint:get(owner, Components.Shared.Inputs)
	if not inputs then return end
	inputs[GetInputKey(inputObject)] = { state = inputState }
end

function operations.BindInput(owner: jecs.Entity, data: Types.BindInputRequestData)
	if ContextActionAdapter.IsBound(data.actionName) then return end

	ContextActionAdapter.BindAction(data.actionName, function(_actionName, inputState, inputObject)
		operations.LogInput(owner, inputObject, inputState)
		return Enum.ContextActionResult.Pass
	end, data.createTouchButton or false, unpack(data.inputTypes))
end

function operations.UnbindInput(data: Types.UnbindInputRequestData)
	ContextActionAdapter.UnbindAction(data.actionName)
end

function operations.IsBound(actionName: string): boolean
	return ContextActionAdapter.IsBound(actionName)
end

return operations
