--!strict
--[[
	Интерфейсы агрегатов. Реализация (Aggregates/) и потребители (Services/, API/)
	зависят от этих типов, а не друг от друга.
]]

local UIWrapperTypes = require(script.Parent.UIWrapperTypes)

--[[
	I     - тип инстанса
	E     - допустимые имена событий
	N     - допустимые имена эффектов
	Entry - записи для EmitEffect
]]
export type IUIAggregate<I, E, N, Entry> = {
	instance: I,
	_Janitor: any,
	miscData: { [string]: any },
	effects: { [string]: any },

	-- подписка на свойство: AddPropertyChangedCallback("Visible", "id", function(value) end)
	AddPropertyChangedCallback: (
		self: IUIAggregate<I, E, N, Entry>,
		property: string,
		id: string,
		cb: (value: any) -> ()
	) -> string,
	RemovePropertyChangedCallback: (self: IUIAggregate<I, E, N, Entry>, property: string, id: string) -> (),

	AddCallback: (self: IUIAggregate<I, E, N, Entry>, event: E, id: string, cb: UIWrapperTypes.Callback) -> string,
	RemoveCallback: (self: IUIAggregate<I, E, N, Entry>, event: E, id: string) -> (),
	RemoveAllCallbacks: (self: IUIAggregate<I, E, N, Entry>) -> (),

	Fire: (self: IUIAggregate<I, E, N, Entry>, event: E, ...any) -> (),

	ApplyEffect: (self: IUIAggregate<I, E, N, Entry>, names: { N }) -> (),
	EmitEffect: (self: IUIAggregate<I, E, N, Entry>, entries: { Entry }) -> (),

	IsDestroyed: (self: IUIAggregate<I, E, N, Entry>) -> boolean,
	Destroy: (self: IUIAggregate<I, E, N, Entry>) -> (),
}

export type IUIButtonAggregate<I = GuiButton> = IUIAggregate<
	I,
	UIWrapperTypes.GUIButtonCallbackType,
	UIWrapperTypes.UIButtonEffectName,
	UIWrapperTypes.UIButtonEffectEntry
>

export type IUIFrameAggregate<I = GuiObject> = IUIAggregate<
	I,
	UIWrapperTypes.GUIFrameCallbackType,
	UIWrapperTypes.UIFrameEffectName,
	UIWrapperTypes.UIFrameEffectEntry
>

export type AnyAggregate = IUIButtonAggregate | IUIFrameAggregate

--[[
	Минимум, который нужен эффектам от агрегата. Так как SpringEffect общий
	для Button и Frame, эффекты не привязаны ни к одному из интерфейсов.
]]
export type IEffectHost = {
	instance: GuiObject,
	miscData: { [string]: any },
	_janitor: any,
	AddCallback: (self: any, event: any, id: string, cb: UIWrapperTypes.Callback) -> string,
	RemoveCallback: (self: any, event: any, id: string) -> (),
}

--[[
	Аналог WrapperFor<T> из TS: перегрузка по типу инстанса.
	GuiButton -> кнопочный агрегат, любой другой GuiObject -> Frame-агрегат.
]]
export type CreateWrapperFn =
	((self: any, instance: GuiButton) -> IUIButtonAggregate)
	& ((self: any, instance: GuiObject) -> IUIFrameAggregate)

export type GetWrapperFn =
	((self: any, instance: GuiButton) -> IUIButtonAggregate?)
	& ((self: any, instance: GuiObject) -> IUIFrameAggregate?)

return {}
