--!strict
--[[
	Только данные и типы (как Components в ECS-пакетах): ни одной реализации.

	Два слоя:
	  * WrapperState - внутренние данные обёртки (то, с чем работают Operations/Systems);
	  * ButtonWrapper<I> / FrameWrapper<I> - объект, который возвращает API. Это состояние +
	    методы для вызова через ":"; сами методы - тонкие делегаты в Systems (Resources/Handles).

	I - точный тип инстанса: API.CreateButton(textButton) даёт ButtonWrapper<TextButton>,
	поэтому wrapper.instance сохраняет свой тип (.Text, .Image и т.д.).
]]

local Signal = require("@RbxPackages/signal")
local Janitor = require("@RbxPackages/janitor")
local Types = require("./Types")

--[[
	Только те методы Janitor, которые использует модуль. Полный тип Janitor - рекурсивный
	typeof(setmetatable(...)) с generic-методами, и старый солвер Luau не может сравнить его
	сам с собой ("Expected exactly Janitor, but got Janitor"): любая таблица с таким полем
	перестаёт проходить через массивы и параметры. Узкий интерфейс этой проблемы не имеет.
]]
export type Cleaner = {
	Add: (self: any, object: any, methodName: (boolean | string)?, index: any?) -> any,
	Remove: (self: any, index: any) -> any,
	Destroy: (self: any) -> (),
}

export type WrapperState = {
	instance: GuiObject,
	miscData: { [string]: any }, -- пользовательский "мешок" данных
	_toggles: { [string]: boolean }, -- флаги переключаемых эффектов (ScaleOnActivate)

	_janitor: Janitor.Janitor,
	_options: Options,
	_signals: { [string]: Signal.Signal<...any> }, -- event -> мультикаст для AddCallback/Fire
	_callbacks: { [string]: { [string]: Signal.Connection } }, -- event -> { [id]: Connection }
	_connected: { [string]: boolean }, -- event -> true, если реальный RBXScriptSignal уже подключён
	_destroyed: boolean,
	_onDestroy: ((WrapperState) -> ())?,
}

-- Эффект-пресет (реализации в Resources/Effects). params: any - осознанно: у каждого эффекта
-- свой тип params, а реестр хранит их вместе; снаружи params типизированы через *EffectEntry.
-- Apply есть только у пассивных эффектов (ScaleOnEnter).
export type Effect = {
	Emit: (wrapper: WrapperState, params: any) -> (),
	Apply: ((wrapper: WrapperState) -> ())?,
}

-- Что задаёт тип обёртки: имя (для ошибок), разрешённые события и доступные эффекты.
-- Собирается в Resources/WrapperOptions/*
export type Options = {
	name: string,
	events: { [string]: boolean },
	effects: { [string]: Effect },
}

export type ButtonWrapper<I = GuiButton> = {
	instance: I,
	miscData: { [string]: any },
	_janitor: Janitor.Janitor,
	_state: WrapperState,

	AddCallback: (self: ButtonWrapper<I>, event: Types.GUIButtonCallbackType, id: string, cb: Types.Callback) -> string,
	RemoveCallback: (self: ButtonWrapper<I>, event: Types.GUIButtonCallbackType, id: string) -> (),
	RemoveAllCallbacks: (self: ButtonWrapper<I>) -> (),
	Fire: (self: ButtonWrapper<I>, event: Types.GUIButtonCallbackType, ...any) -> (),

	AddPropertyChangedCallback: (
		self: ButtonWrapper<I>,
		property: string,
		id: string,
		cb: (value: any) -> ()
	) -> string,
	RemovePropertyChangedCallback: (self: ButtonWrapper<I>, property: string, id: string) -> (),

	ApplyEffect: (self: ButtonWrapper<I>, names: { Types.UIButtonEffectName }) -> (),
	EmitEffect: (self: ButtonWrapper<I>, entries: { Types.UIButtonEffectEntry }) -> (),

	IsDestroyed: (self: ButtonWrapper<I>) -> boolean,
	Destroy: (self: ButtonWrapper<I>) -> (),
}

export type FrameWrapper<I = GuiObject> = {
	instance: I,
	miscData: { [string]: any },
	_state: WrapperState,

	AddCallback: (self: FrameWrapper<I>, event: Types.GUIFrameCallbackType, id: string, cb: Types.Callback) -> string,
	RemoveCallback: (self: FrameWrapper<I>, event: Types.GUIFrameCallbackType, id: string) -> (),
	RemoveAllCallbacks: (self: FrameWrapper<I>) -> (),
	Fire: (self: FrameWrapper<I>, event: Types.GUIFrameCallbackType, ...any) -> (),

	AddPropertyChangedCallback: (self: FrameWrapper<I>, property: string, id: string, cb: (value: any) -> ()) -> string,
	RemovePropertyChangedCallback: (self: FrameWrapper<I>, property: string, id: string) -> (),

	ApplyEffect: (self: FrameWrapper<I>, names: { Types.UIFrameEffectName }) -> (),
	EmitEffect: (self: FrameWrapper<I>, entries: { Types.UIFrameEffectEntry }) -> (),

	IsDestroyed: (self: FrameWrapper<I>) -> boolean,
	Destroy: (self: FrameWrapper<I>) -> (),
}

-- Готовые инстанциации для реестра и GetAll: один общий тип на все модули
-- (старый солвер сравнивает разные инстанциации ButtonWrapper<GuiButton> в разных файлах глубоко и спотыкается).
export type AnyButtonWrapper = ButtonWrapper<GuiButton>
export type AnyFrameWrapper = FrameWrapper<GuiObject>
export type AnyWrapper = AnyButtonWrapper | AnyFrameWrapper

return {}
