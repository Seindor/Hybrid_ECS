--!strict
--[[
	Сборка внутренних данных обёртки (без методов). Подписки на Destroying и регистрация -
	в Systems/*CreationSystem.
]]

local Janitor = require("@RbxPackages/janitor")
local Components = require("../Data/Components")

local operations = {}

function operations.Create(
	instance: GuiObject,
	options: Components.Options,
	onDestroy: ((Components.WrapperState) -> ())?
): Components.WrapperState
	return {
		instance = instance,
		miscData = {},
		_toggles = {},

		_janitor = Janitor.new() :: any, -- полный тип Janitor -> узкий Components.Cleaner (см. комментарий там)
		_options = options,
		_signals = {},
		_callbacks = {},
		_connected = {},
		_destroyed = false,
		_onDestroy = onDestroy,
	}
end

return operations
