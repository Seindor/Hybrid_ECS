local SharedTypes = require("@SharedGameplay/InputModule/Data/Types")
local jecs = require("@RbxPackages/jecs")

export type InputRecord = SharedTypes.InputRecord
export type InputSnapshot = SharedTypes.InputSnapshot

export type InputCallback = (
	actionName: string,
	inputState: Enum.UserInputState,
	inputObject: InputObject
) -> Enum.ContextActionResult?

export type BindInputRequestData = {
	owner: jecs.Entity,
	actionName: string,
	inputTypes: { (Enum.UserInputType | Enum.KeyCode) },
	createTouchButton: boolean?,
}

export type UnbindInputRequestData = {
	actionName: string,
}

return {}