--!strict
--[[
	Реестр эффектов. Реализации общие: SpringEffect - один файл для Button и Frame,
	различается только список доступных эффектов у каждого типа обёртки
	(Resources/WrapperOptions/Button.luau и Frame.luau).

	Чтобы добавить эффект: файл в Resources/Effects + строка тут + имя/entry
	в Data/Types.
]]

local Types = require("../Data/Types")

local ScaleOnEnter = require("./Effects/ScaleOnEnter")
local ScaleOnActivate = require("./Effects/ScaleOnActivate")
local SpringEffect = require("./Effects/SpringEffect")
local MoveFrame = require("./Effects/MoveFrame")
local CurrencyPopupEffect = require("./Effects/CurrencyPopupEffect")

return {
	Button = {
		ScaleOnEnter = ScaleOnEnter,
		SpringEffect = SpringEffect,
	} :: { [string]: Types.IEffectClass },

	Frame = {
		ScaleOnActivate = ScaleOnActivate,
		SpringEffect = SpringEffect,
		CurrencyPopupEffect = CurrencyPopupEffect,
		MoveFrame = MoveFrame,
	} :: { [string]: Types.IEffectClass },
}
