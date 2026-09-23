--!strict
--[[
	Интерфейсы агрегатов. Реализация (Aggregates/) и потребители (Services/, API/)
	зависят от этих типов, а не друг от друга.
]]

local UIWrapperTypes = require("./UIWrapperTypes")

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

--[[
	I - конкретный тип кнопки: IUIButtonAggregate<TextButton>, IUIButtonAggregate<ImageButton>.
	Без параметра - просто GuiButton.
]]
export type IUIButtonAggregate<I = GuiButton> = IUIAggregate<
	I,
	UIWrapperTypes.GUIButtonCallbackType,
	UIWrapperTypes.UIButtonEffectName,
	UIWrapperTypes.UIButtonEffectEntry
>

--[[
	I - конкретный тип элемента: IUIFrameAggregate<Frame>, IUIFrameAggregate<ScrollingFrame>.
	Без параметра - просто GuiObject.
]]
export type IUIFrameAggregate<I = GuiObject> = IUIAggregate<
	I,
	UIWrapperTypes.GUIFrameCallbackType,
	UIWrapperTypes.UIFrameEffectName,
	UIWrapperTypes.UIFrameEffectEntry
>

export type IUICommonAggregate = IUIAggregate<
	GuiObject,
	UIWrapperTypes.GUICommonCallbackType,
	"SpringEffect",
	{ Name: "SpringEffect", Params: UIWrapperTypes.SpringEffectParams? }
>

--[[
	Минимум, который нужен эффектам от агрегата. Так как SpringEffect общий
	для Button и Frame, эффекты не привязаны ни к одному из интерфейсов.
]]
export type IEffectHost = {
	instance: GuiObject,
	miscData: { [string]: any },
	_Janitor: any,
	AddCallback: (self: any, event: any, id: string, cb: UIWrapperTypes.Callback) -> string,
	RemoveCallback: (self: any, event: any, id: string) -> (),
}

return {}
