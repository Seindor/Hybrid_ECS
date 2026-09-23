--!strict
--[[
	Создание состояния обёртки и её уничтожение. Аналог QuestsConstructionOperations.
	metatable тут не ставится - это делает Systems/UIWrapper.
]]

local WrapperState = require("../Data/WrapperState")
local Types = require("../Data/Types")
local WrapperCallbacksOperations = require("./WrapperCallbacksOperations")

type State = WrapperState.WrapperState

local operations = {}

function operations.Create(
	instance: GuiObject,
	options: Types.Options,
	onDestroy: ((State) -> ())?
): State
	local self = WrapperState.New(instance, options, onDestroy)

	self._janitor:Add(
		instance.Destroying:Connect(function()
			WrapperCallbacksOperations.Fire(self, "Destroying")
			operations.Destroy(self)
		end),
		"Disconnect",
		"Event:Destroying"
	)

	return self
end

function operations.IsDestroyed(self: State): boolean
	return self._destroyed
end

function operations.Destroy(self: State)
	if self._destroyed then return end
	self._destroyed = true

	table.clear(self._callbacks)
	table.clear(self._connected)
	table.clear(self.effects)

	for _, signal in self._signals do
		signal:Destroy()
	end
	table.clear(self._signals)

	self._janitor:Destroy() -- рвёт все реальные RBXScriptSignal-коннекты разом

	local onDestroy = self._onDestroy
	self._onDestroy = nil
	if onDestroy then onDestroy(self) end
end

return operations
