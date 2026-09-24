--!strict
--[[
	Реестр эффектов. Реализации общие: SpringEffect - один файл для Button и Frame,
	различается только список доступных эффектов у каждого типа обёртки
	(Resources/WrapperOptions/Button.luau и Frame.luau).

	Чтобы добавить эффект: файл в Resources/Effects + строка тут + имя/entry в Data/Types.
]]

local Components = require("../Data/Components")

local ScaleOnEnter = require("./Effects/ScaleOnEnter")
local ScaleOnActivate = require("./Effects/ScaleOnActivate")
local SpringEffect = require("./Effects/SpringEffect")
local MoveFrame = require("./Effects/MoveFrame")
local CurrencyPopupEffect = require("./Effects/CurrencyPopupEffect")

local button: { [string]: Components.Effect } = {
	ScaleOnEnter = ScaleOnEnter,
	SpringEffect = SpringEffect,
}

local frame: { [string]: Components.Effect } = {
	ScaleOnActivate = ScaleOnActivate,
	SpringEffect = SpringEffect,
	CurrencyPopupEffect = CurrencyPopupEffect,
	MoveFrame = MoveFrame,
}

return {
	Button = button,
	Frame = frame,
}
