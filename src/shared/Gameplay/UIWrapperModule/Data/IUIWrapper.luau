--!strict
--[[
	Единый интерфейс UI-обёртки. UIAggregate/UIButtonAggregate/UIFrameAggregate упразднены -
	есть один класс (Systems/UIWrapper.luau), различается только его Options
	(Resources/WrapperOptions/*) и generic-параметры этого типа.

	Реализация (Systems/, Operations/) и потребители (Systems/, UIWrapperAPI) зависят от этих
	типов, а не друг от друга - как Data/Types в ECS-пакетах.
]]

local Janitor = require("@RbxPackages/janitor")
local Types = require("./Types")

--[[
	I     - тип инстанса
	E     - допустимые имена событий
	N     - допустимые имена эффектов
	Entry - записи для EmitEffect
]]
export type IUIWrapper<I, E, N, Entry> = {
	instance: I,
	miscData: { [string]: any },
	effects: { [string]: Types.IEffect },
	_janitor: Janitor.Janitor,

	AddPropertyChangedCallback: (
		self: IUIWrapper<I, E, N, Entry>,
		property: string,
		id: string,
		cb: (value: any) -> ()
	) -> string,
	RemovePropertyChangedCallback: (self: IUIWrapper<I, E, N, Entry>, property: string, id: string) -> (),

	AddCallback: (self: IUIWrapper<I, E, N, Entry>, event: E, id: string, cb: Types.Callback) -> string,
	RemoveCallback: (self: IUIWrapper<I, E, N, Entry>, event: E, id: string) -> (),
	RemoveAllCallbacks: (self: IUIWrapper<I, E, N, Entry>) -> (),

	Fire: (self: IUIWrapper<I, E, N, Entry>, event: E, ...any) -> (),

	ApplyEffect: (self: IUIWrapper<I, E, N, Entry>, names: { N }) -> (),
	EmitEffect: (self: IUIWrapper<I, E, N, Entry>, entries: { Entry }) -> (),

	IsDestroyed: (self: IUIWrapper<I, E, N, Entry>) -> boolean,
	Destroy: (self: IUIWrapper<I, E, N, Entry>) -> (),
}

--[[
	I - конкретный тип кнопки: IUIButtonWrapper<TextButton>, IUIButtonWrapper<ImageButton>.
	Без параметра - просто GuiButton.
]]
export type IUIButtonWrapper<I = GuiButton> = IUIWrapper<
	I,
	Types.GUIButtonCallbackType,
	Types.UIButtonEffectName,
	Types.UIButtonEffectEntry
>

--[[
	I - конкретный тип элемента: IUIFrameWrapper<Frame>, IUIFrameWrapper<ScrollingFrame>.
	Без параметра - просто GuiObject.
]]
export type IUIFrameWrapper<I = GuiObject> = IUIWrapper<
	I,
	Types.GUIFrameCallbackType,
	Types.UIFrameEffectName,
	Types.UIFrameEffectEntry
>

export type IUICommonWrapper = IUIWrapper<
	GuiObject,
	Types.GUICommonCallbackType,
	"SpringEffect",
	{ name: "SpringEffect", params: Types.SpringEffectParams? }
>

-- Определён в Types (нужен Options, а Types не может зависеть от этого файла)
export type IEffectHost = Types.IEffectHost

return {}
