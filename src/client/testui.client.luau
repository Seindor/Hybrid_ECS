local Players = game:GetService("Players")

local UIWrapperAPI = require("@SharedGameplay/UIWrapperModule/API/UIWrapperAPI")

local uiWrapperAPI = UIWrapperAPI.new()

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

export type IScreenGui = {
	["TextButton"]: {
		["UIScale"]: UIScale,
	} & TextButton,
} & ScreenGui

local screenGui = playerGui:WaitForChild("ScreenGui") :: IScreenGui

local button = uiWrapperAPI:CreateButton(screenGui.TextButton)

button:AddCallback("Activated", "Test", function()
	button._janitor:Add(
		task.spawn(function()
			button._janitor:Remove("RemoveSpring")

			button:EmitEffect({
				{ name = "SpringEffect", params = { startScale = 1, targetScale = 1.2, duration = 0.2 } },
			})
		end),
		true,
		"AddSpring"
	)

	button._janitor:Add(
		task.delay(0.2, function()
			button._janitor:Remove("AddSpring")

			button:EmitEffect({
				{ name = "SpringEffect", params = { startScale = 1.2, targetScale = 1, duration = 0.1 } },
			})
		end),
		true,
		"RemoveSpring"
	)
end)
