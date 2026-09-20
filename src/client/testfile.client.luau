local Players = game:GetService("Players")

local api = require("@SharedGameplay/UIWrapper/APIs/UIWrapperAPI")
local uiWrapperAPI = api.new()

export type IScreenGui = {
	["TextButton"]: TextButton,
} & ScreenGui

local player = Players.LocalPlayer

local playerGui = player.PlayerGui
local screenGui = playerGui:WaitForChild("ScreenGui") :: IScreenGui

local button = uiWrapperAPI:CreateButton(screenGui.TextButton)

button:AddCallback("Activated", "LolTest", function()
	print("Activated")
end)
