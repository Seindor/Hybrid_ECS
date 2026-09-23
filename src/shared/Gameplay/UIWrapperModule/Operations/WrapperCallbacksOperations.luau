--!strict
--[[
	Подписка на события инстанса и мультикаст колбэков. Мультикаст отдан
	sleitnick/signal вместо ручного table.clone + task.spawn по каждому колбэку -
	Signal сам изолирует подписчиков друг от друга.

	Связь с реальным GuiObject лениво подключается при первом AddCallback и
	отключается, когда у события не остаётся ни одного колбэка (как раньше в UIAggregate).
]]

local Signal = require("@RbxPackages/signal")

local Types = require("../Data/Types")
local WrapperState = require("../Data/WrapperState")

type State = WrapperState.WrapperState

local operations = {}

local EVENT_KEY = "Event:"

local function getSignal(self: State, event: Types.EventName): Signal.Signal<...any>
	local signal = self._signals[event]
	if not signal then
		local created: Signal.Signal<...any> = Signal.new()
		self._signals[event] = created
		return created
	end
	return signal
end

-- Единственное место, где событие ищется по имени: RBXScriptSignal достаётся рефлексией.
local function getInstanceSignal(instance: GuiObject, event: Types.EventName): RBXScriptSignal
	return (instance :: any)[event] :: RBXScriptSignal
end

-- Подключает реальный RBXScriptSignal к внутреннему Signal, если ещё не подключён
function operations.Connect(self: State, event: Types.EventName)
	if event == "Destroying" or self._connected[event] then return end

	if not self._options.events[event] then
		error(`Событие "{event}" недоступно для {self._options.name} ({self.instance:GetFullName()})`, 3)
	end

	self._connected[event] = true
	local signal = getSignal(self, event)
	local instance = self.instance

	if event == "Shown" or event == "Hidden" then
		local wantVisible = event == "Shown"
		self._janitor:Add(
			instance:GetPropertyChangedSignal("Visible"):Connect(function()
				if instance.Visible == wantVisible then signal:Fire() end
			end),
			"Disconnect",
			EVENT_KEY .. event
		)
	else
		self._janitor:Add(
			getInstanceSignal(instance, event):Connect(function(...: any)
				signal:Fire(...)
			end),
			"Disconnect",
			EVENT_KEY .. event
		)
	end
end

function operations.Disconnect(self: State, event: Types.EventName)
	if event == "Destroying" or not self._connected[event] then return end
	self._connected[event] = nil
	self._janitor:Remove(EVENT_KEY .. event)
end

function operations.AddCallback(self: State, event: Types.EventName, id: string, cb: Types.Callback): string
	if self._destroyed then return id end

	operations.Connect(self, event) -- кинет ошибку, если событие недоступно

	local map = self._callbacks[event]
	if not map then
		map = {}
		self._callbacks[event] = map
	end

	local previous = map[id]
	if previous then previous:Disconnect() end
	map[id] = getSignal(self, event):Connect(cb)

	return id
end

function operations.RemoveCallback(self: State, event: Types.EventName, id: string)
	local map = self._callbacks[event]
	if not map then return end

	local connection = map[id]
	if connection then connection:Disconnect() end
	map[id] = nil

	if next(map) == nil then
		self._callbacks[event] = nil
		operations.Disconnect(self, event)
	end
end

function operations.RemoveAllCallbacks(self: State)
	for event, map in self._callbacks do
		for _, connection in map do
			connection:Disconnect()
		end
		operations.Disconnect(self, event :: Types.EventName)
	end
	table.clear(self._callbacks)
end

-- Fire("Destroying") дергается вручную (не через реальный RBXScriptSignal),
-- поэтому не требует self._connected[event]
function operations.Fire(self: State, event: Types.EventName, ...: any)
	local signal = self._signals[event]
	if not signal then return end
	signal:Fire(...)
end

return operations
