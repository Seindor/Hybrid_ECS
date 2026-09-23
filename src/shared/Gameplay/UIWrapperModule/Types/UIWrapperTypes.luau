--!strict
--[[
	Только типы, ничего не require'ит (доступно всем слоям).
]]

export type Callback = (...any) -> ()

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

export type UIButtonEffectEntry = { Name: "ScaleOnEnter" } | { Name: "SpringEffect", Params: SpringEffectParams? }

export type UIFrameEffectEntry =
	{ Name: "ScaleOnActivate" }
	| { Name: "SpringEffect", Params: SpringEffectParams? }
	| { Name: "CurrencyPopupEffect", Params: CurrencyPopupParams }
	| { Name: "MoveFrame", Params: MoveFrameParams? }

return {}
