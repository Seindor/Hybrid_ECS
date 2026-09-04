local Types = require("../../Data/Types")

local behavior = {} :: Types.IInputBehavior

function behavior.Handle(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject)
	if inputState == Enum.UserInputState.Begin then
		print(`{actionName} started ({inputObject.KeyCode})`)
	end

	return Enum.ContextActionResult.Pass
end

return behavior