--!strict
--[[
	Аналог Components из ECS-пакетов: форма данных одной обёртки.
	Поля с "_" - внутренние (см. IUIWrapper). Только данные и фабрика, без логики.
]]

local Janitor = require("@RbxPackages/janitor")
local Signal = require("@RbxPackages/signal")
local Types = require("./Types")

export type WrapperState = {
	instance: GuiObject,
	miscData: { [string]: any }, -- пользовательский "мешок" данных
	effects: { [string]: Types.IEffect }, -- name -> экземпляр эффекта (создаётся лениво)

	_janitor: Janitor.Janitor,
	_options: Types.Options,
	_signals: { [string]: Signal.Signal<...any> }, -- event -> мультикаст для AddCallback/Fire
	_callbacks: { [string]: { [string]: Signal.Connection } }, -- event -> { [id]: Connection }
	_connected: { [string]: boolean }, -- event -> true, если реальный RBXScriptSignal уже подключён
	_destroyed: boolean,
	_onDestroy: ((WrapperState) -> ())?,
}

local WrapperState = {}

function WrapperState.New(
	instance: GuiObject,
	options: Types.Options,
	onDestroy: ((WrapperState) -> ())?
): WrapperState
	return {
		instance = instance,
		miscData = {},
		effects = {},
		_janitor = Janitor.new(),
		_options = options,
		_signals = {},
		_callbacks = {},
		_connected = {},
		_destroyed = false,
		_onDestroy = onDestroy,
	}
end

return WrapperState
