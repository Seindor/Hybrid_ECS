export type InputCallback = (
	actionName: string,
	inputState: Enum.UserInputState,
	inputObject: InputObject
) -> Enum.ContextActionResult?

export type IInputBehavior = {
	Handle: InputCallback,
}

export type BindInputRequestData = {
	actionName: string,
	inputTypes: { (Enum.UserInputType | Enum.KeyCode) },
	createTouchButton: boolean?,
}

export type UnbindInputRequestData = {
	actionName: string,
}

return {}