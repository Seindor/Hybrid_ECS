--!strict
--[[
	Только типы (единственная зависимость - тип Janitor), доступно всем слоям. Не ECS - модуль клиентский,
	OOP-обёртка над GuiObject, а не entity.
]]

local Janitor = require("@RbxPackages/janitor")

export type Callback = (...any) -> ()

--[[
	Минимум, который нужен эффектам от обёртки. Эффекты не привязаны ни к Button, ни к Frame,
	поэтому вместо полного IUIWrapper<...> - узкий структурный интерфейс.
	miscData - произвольный пользовательский "мешок" данных, поэтому any.
]]
export type IEffectHost = {
	instance: GuiObject,
	miscData: { [string]: any },
	_janitor: Janitor.Janitor,
	AddCallback: (self: IEffectHost, event: EventName, id: string, cb: Callback) -> string,
}

--[[
	Эффект. params: any - осознанно: у каждого эффекта свой тип params, а реестр хранит их вместе;
	снаружи params типизированы через UIButtonEffectEntry / UIFrameEffectEntry.
	Apply есть только у пассивных эффектов (ScaleOnEnter).
]]
export type IEffect = {
	Emit: (self: any, params: any?) -> (),
	Apply: ((self: any) -> ())?,
}

export type IEffectClass = {
	new: (host: IEffectHost) -> IEffect,
}

-- Что задаёт тип обёртки: имя (для ошибок), разрешённые события и реестр эффектов.
-- Собирается в Resources/WrapperOptions/*
export type Options = {
	name: string,
	events: { [string]: boolean },
	effects: { [string]: IEffectClass },
}

export type FrameInstanceType = GuiObject

--[[
	Поля таблиц в Luau инвариантны: { target = frame } не пройдёт в поле типа GuiObject,
	если frame: Frame. Поэтому перечисляем частые классы явно.
]]
export type GuiTarget =
	GuiObject
	| Frame
	| TextLabel
	| TextButton
	| TextBox
	| ImageLabel
	| ImageButton
	| ScrollingFrame
	| CanvasGroup
	| ViewportFrame

--------------------------------------------------------------------------------
-- События
--------------------------------------------------------------------------------

export type GUICommonCallbackType =
	"InputBegan"
	| "InputEnded"
	| "InputChanged"
	| "MouseEnter"
	| "MouseLeave"
	| "MouseMoved"
	| "MouseWheelForward"
	| "MouseWheelBackward"
	| "Destroying"

export type GUIButtonCallbackType =
	GUICommonCallbackType
	| "Activated"
	| "SecondaryActivated"
	| "MouseButton1Click"
	| "MouseButton1Down"
	| "MouseButton1Up"
	| "MouseButton2Click"
	| "MouseButton2Down"
	| "MouseButton2Up"

export type GUIFrameCallbackType = GUICommonCallbackType | "Shown" | "Hidden"

-- Любое событие любой обёртки
export type EventName = GUIButtonCallbackType | GUIFrameCallbackType

--------------------------------------------------------------------------------
-- Параметры эффектов
--------------------------------------------------------------------------------

-- Можно передавать как Enum.EasingStyle.Quart, так и строку "Quart"
export type EasingStyle = Enum.EasingStyle | string
export type EasingDirection = Enum.EasingDirection | string

export type SpringEffectParams = {
	damping: number?,
	frequency: number?,
	amplitude: number?,
	duration: number?,
	startScale: number?,
	targetScale: number?,
}

export type MoveFrameParams = {
	duration: number?,
	target: UDim2?,
	style: EasingStyle?,
	direction: EasingDirection?,
}

export type CurrencyPopupParams = {
	target: GuiTarget,
	bezierDuration: number?,
	controlPos: UDim2?,
	offset: UDim2?,
	spawnScaleDuration: number?,
	fadeScaleStart: number?,
}

--------------------------------------------------------------------------------
-- Эффекты
--------------------------------------------------------------------------------

export type UIButtonEffectName = "ScaleOnEnter" | "SpringEffect"

export type UIFrameEffectName = "ScaleOnActivate" | "SpringEffect" | "CurrencyPopupEffect" | "MoveFrame"

-- name/params - подсказки автокомплита: тип params сужается автоматически по выбранному name.
-- button:EmitEffect({ { name = "SpringEffect", params = { duration = 0.5 } } })
export type UIButtonEffectEntry = { name: "ScaleOnEnter" } | { name: "SpringEffect", params: SpringEffectParams? }

export type UIFrameEffectEntry =
	{ name: "ScaleOnActivate" }
	| { name: "SpringEffect", params: SpringEffectParams? }
	| { name: "CurrencyPopupEffect", params: CurrencyPopupParams }
	| { name: "MoveFrame", params: MoveFrameParams? }

return {}
