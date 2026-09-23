--!strict
--[[
	Полный тип живой обёртки: данные (WrapperState) + то, что видят эффекты (IEffectHost).
	Нужен там, где обёртку передают эффектам: EffectsOperations, UIWrapper, реестр.
]]

local WrapperState = require("./WrapperState")
local Types = require("./Types")

export type Wrapper = WrapperState.WrapperState & Types.IEffectHost

return {}
