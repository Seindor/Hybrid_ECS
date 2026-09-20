--!strict
--[[
	Общая реализация агрегата. Напрямую не используется - см. UIButtonAggregate
	и UIFrameAggregate: они передают сюда набор разрешённых событий и реестр эффектов.

	Зависимости: только Components (эффекты) и Types.

	Отличия от старой версии:
	  * события подключаются лениво - при первом AddCallback и отключаются с последним
	    (раньше на каждый элемент вешалось ~16 коннектов, включая MouseMoved/InputChanged);
	  * Shown/Hidden срабатывают один раз на изменение Visible (раньше - дважды);
	  * Fire не отменяет ещё выполняющиеся колбэки (раньше поток клался в janitor по id колбэка);
	  * Destroy идемпотентен и уведомляет владельца (Service) через onDestroy.
]]

-- поправь путь под свой проект
local Janitor = require("@RbxPackages/janitor")

local UIWrapperTypes = require("../Types/UIWrapperTypes")

local EVENT_KEY = "Event:"
local PROPERTY_KEY = "Property:"

local UIAggregate = {}
UIAggregate.__index = UIAggregate

export type Options = {
	name: string, -- для сообщений об ошибках
	events: { [string]: boolean }, -- разрешённые события
	effects: { [string]: any }, -- реестр эффектов (Components/Effects)
}

export type Impl = typeof(setmetatable(
	{} :: {
		instance: GuiObject,
		miscData: { [string]: any },
		effects: { [string]: any },
		_Janitor: any,
		_options: Options,
		_callbacks: { [string]: { [string]: UIWrapperTypes.Callback } },
		_connected: { [string]: boolean },
		_destroyed: boolean,
		_onDestroy: ((any) -> ())?,
	},
	UIAggregate
))

--[[
	onDestroy - хук для владельца (UIWrapperService), чтобы убрать агрегат из своего реестра.
]]
function UIAggregate.new(instance: GuiObject, options: Options, onDestroy: ((any) -> ())?): Impl
	local self: Impl = setmetatable({
		instance = instance,
		miscData = {},
		effects = {},
		_Janitor = Janitor.new(),
		_options = options,
		_callbacks = {},
		_connected = {},
		_destroyed = false,
		_onDestroy = onDestroy,
	}, UIAggregate)

	self._Janitor:Add(
		instance.Destroying:Connect(function()
			self:Fire("Destroying")
			self:Destroy()
		end),
		"Disconnect",
		EVENT_KEY .. "Destroying"
	)

	return self
end

--------------------------------------------------------------------------------
-- События
--------------------------------------------------------------------------------

-- Подключает сигнал события, если ещё не подключён
function UIAggregate._connect(self: Impl, event: string)
	if event == "Destroying" or self._connected[event] then return end

	if not self._options.events[event] then
		error(
			`Событие "{event}" недоступно для {self._options.name} ({self.instance:GetFullName()})`,
			3
		)
	end

	local instance = self.instance

	local function connect(signal: RBXScriptSignal, handler: (...any) -> ())
		self._connected[event] = true
		self._Janitor:Add(signal:Connect(handler), "Disconnect", EVENT_KEY .. event)
	end

	if event == "Shown" or event == "Hidden" then
		local wantVisible = event == "Shown"
		connect(instance:GetPropertyChangedSignal("Visible"), function()
			if instance.Visible == wantVisible then self:Fire(event) end
		end)
	else
		connect((instance :: any)[event], function(...)
			self:Fire(event, ...)
		end)
	end
end

function UIAggregate._disconnect(self: Impl, event: string)
	if event == "Destroying" or not self._connected[event] then return end

	self._connected[event] = nil
	self._Janitor:Remove(EVENT_KEY .. event)
end

function UIAggregate.AddCallback(self: Impl, event: string, id: string, cb: UIWrapperTypes.Callback): string
	if self._destroyed then return id end

	self:_connect(event) -- кинет ошибку, если событие недоступно

	local map = self._callbacks[event]
	if not map then
		map = {}
		self._callbacks[event] = map
	end
	map[id] = cb

	return id
end

function UIAggregate.RemoveCallback(self: Impl, event: string, id: string)
	local map = self._callbacks[event]
	if not map then return end

	map[id] = nil

	if next(map) == nil then
		self._callbacks[event] = nil
		self:_disconnect(event)
	end
end

function UIAggregate.RemoveAllCallbacks(self: Impl)
	for event in self._callbacks do
		self:_disconnect(event)
	end
	table.clear(self._callbacks)
end

function UIAggregate.Fire(self: Impl, event: string, ...: any)
	local map = self._callbacks[event]
	if not map then return end

	-- копия: колбэк может добавлять/удалять колбэки во время обхода
	for _, cb in table.clone(map) do
		task.spawn(cb, ...)
	end
end

--[[
	AddPropertyChangedCallback("Visible", "id", function(value) end)
	(раньше нужно было писать "VisibleChanged" - суффикс обрезался через sub)
]]
function UIAggregate.AddPropertyChangedCallback(
	self: Impl,
	property: string,
	id: string,
	cb: (value: any) -> ()
): string
	if self._destroyed then return id end

	local instance = self.instance

	self._Janitor:Add(
		instance:GetPropertyChangedSignal(property):Connect(function()
			cb((instance :: any)[property])
		end),
		"Disconnect",
		`{PROPERTY_KEY}{property}:{id}`
	)

	return id
end

function UIAggregate.RemovePropertyChangedCallback(self: Impl, property: string, id: string)
	if self._destroyed then return end
	self._Janitor:Remove(`{PROPERTY_KEY}{property}:{id}`)
end

--------------------------------------------------------------------------------
-- Эффекты
--------------------------------------------------------------------------------

function UIAggregate._getEffect(self: Impl, name: string): any
	local effect = self.effects[name]

	if not effect then
		local EffectClass = self._options.effects[name]
		if not EffectClass then error(`Эффект "{name}" недоступен для {self._options.name}`, 3) end

		-- cast: эффекты зависят от IEffectHost, а не от конкретного интерфейса агрегата
		effect = EffectClass.new(self :: any)
		self.effects[name] = effect
	end

	return effect
end

-- "Повесить" пассивные эффекты (ScaleOnEnter и т.п.); одноразовые просто создаются
function UIAggregate.ApplyEffect(self: Impl, names: { string })
	if self._destroyed then return end

	for _, name in names do
		local effect = self:_getEffect(name)
		local apply: any = effect.Apply
		if typeof(apply) == "function" then (apply :: any)(effect) end
	end
end

-- Запустить эффекты: { { Name = "SpringEffect", Params = { duration = 0.5 } } }
function UIAggregate.EmitEffect(self: Impl, entries: { { Name: string, Params: any? } })
	if self._destroyed then return end

	for _, entry in entries do
		local effect = self:_getEffect(entry.Name)
		effect:Emit(entry.Params)
	end
end

--------------------------------------------------------------------------------

function UIAggregate.IsDestroyed(self: Impl): boolean
	return self._destroyed
end

function UIAggregate.Destroy(self: Impl)
	if self._destroyed then return end
	self._destroyed = true

	table.clear(self._callbacks)
	table.clear(self._connected)
	table.clear(self.effects)
	self._Janitor:Destroy()

	local onDestroy: any = self._onDestroy
	self._onDestroy = nil
	if typeof(onDestroy) == "function" then (onDestroy :: any)(self) end
end

return UIAggregate
