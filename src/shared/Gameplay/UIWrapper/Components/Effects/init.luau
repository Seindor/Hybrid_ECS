--!strict
--[[
	Реестры эффектов (бывшие Prototypes/Effects). Реализации общие:
	SpringEffect - один файл для Button и Frame, различается только список доступных
	эффектов у каждого типа агрегата (типы - в Types/UIWrapperTypes).

	Чтобы добавить эффект: файл рядом + строка тут + имя/entry в Types/UIWrapperTypes.
]]

local ScaleOnEnter = require("./Effects/ScaleOnEnter")
local ScaleOnActivate = require("./Effects/ScaleOnActivate")
local SpringEffect = require("./Effects/SpringEffect")
local MoveFrame = require("./Effects/MoveFrame")
local CurrencyPopupEffect = require("./Effects/CurrencyPopupEffect")

local Effects = {}

Effects.UIButtonEffectsPrototypes = {
	ScaleOnEnter = ScaleOnEnter,
	SpringEffect = SpringEffect,
} :: { [string]: any }

Effects.UIFrameEffectsPrototypes = {
	ScaleOnActivate = ScaleOnActivate,
	SpringEffect = SpringEffect,
	CurrencyPopupEffect = CurrencyPopupEffect,
	MoveFrame = MoveFrame,
} :: { [string]: any }

return Effects
