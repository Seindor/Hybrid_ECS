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
local Components = require("../Data/Components")

type State = Components.WrapperState

local operations = {}

local EVENT_KEY = "Event:"

local function getSignal(wrapper: State, event: Types.EventName): Signal.Signal<...any>
	local signal = wrapper._signals[event]
	if not signal then
		local created: Signal.Signal<...any> = Signal.new()
		wrapper._signals[event] = created
		return created
	end
	return signal
end

-- Единственное место, где событие ищется по имени: RBXScriptSignal достаётся рефлексией.
local function getInstanceSignal(instance: GuiObject, event: Types.EventName): RBXScriptSignal
	return (instance :: any)[event] :: RBXScriptSignal
end

-- Подключает реальный RBXScriptSignal к внутреннему Signal, если ещё не подключён
function operations.Connect(wrapper: State, event: Types.EventName)
	if event == "Destroying" or wrapper._connected[event] then return end

	if not wrapper._options.events[event] then
		error(`Событие "{event}" недоступно для {wrapper._options.name} ({wrapper.instance:GetFullName()})`, 3)
	end

	wrapper._connected[event] = true
	local signal = getSignal(wrapper, event)
	local instance = wrapper.instance

	if event == "Shown" or event == "Hidden" then
		local wantVisible = event == "Shown"
		wrapper._janitor:Add(
			instance:GetPropertyChangedSignal("Visible"):Connect(function()
				if instance.Visible == wantVisible then signal:Fire() end
			end),
			"Disconnect",
			EVENT_KEY .. event
		)
	else
		wrapper._janitor:Add(
			getInstanceSignal(instance, event):Connect(function(...: any)
				signal:Fire(...)
			end),
			"Disconnect",
			EVENT_KEY .. event
		)
	end
end

function operations.Disconnect(wrapper: State, event: Types.EventName)
	if event == "Destroying" or not wrapper._connected[event] then return end
	wrapper._connected[event] = nil
	wrapper._janitor:Remove(EVENT_KEY .. event)
end

function operations.AddCallback(wrapper: State, event: Types.EventName, id: string, cb: Types.Callback): string
	if wrapper._destroyed then return id end

	operations.Connect(wrapper, event) -- кинет ошибку, если событие недоступно

	local map = wrapper._callbacks[event]
	if not map then
		map = {}
		wrapper._callbacks[event] = map
	end

	local previous = map[id]
	if previous then previous:Disconnect() end
	map[id] = getSignal(wrapper, event):Connect(cb)

	return id
end

function operations.RemoveCallback(wrapper: State, event: Types.EventName, id: string)
	local map = wrapper._callbacks[event]
	if not map then return end

	local connection = map[id]
	if connection then connection:Disconnect() end
	map[id] = nil

	if next(map) == nil then
		wrapper._callbacks[event] = nil
		operations.Disconnect(wrapper, event)
	end
end

function operations.RemoveAllCallbacks(wrapper: State)
	for event, map in wrapper._callbacks do
		for _, connection in map do
			connection:Disconnect()
		end
		operations.Disconnect(wrapper, event :: Types.EventName)
	end
	table.clear(wrapper._callbacks)
end

-- Fire("Destroying") дергается вручную (не через реальный RBXScriptSignal),
-- поэтому не требует wrapper._connected[event]
function operations.Fire(wrapper: State, event: Types.EventName, ...: any)
	local signal = wrapper._signals[event]
	if not signal then return end
	signal:Fire(...)
end

return operations
