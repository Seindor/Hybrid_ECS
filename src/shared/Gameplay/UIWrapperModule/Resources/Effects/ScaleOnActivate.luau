--!strict
--[[
	Каждый Emit переключает масштаб 1 <-> 1.5. Состояние переключателя - в wrapper._toggles.
]]

local Components = require("../../Data/Components")
local UIScaleOperations = require("../../Operations/UIScaleOperations")

local ACTIVE_SCALE = 1.5
local NORMAL_SCALE = 1

local function emit(wrapper: Components.WrapperState)
	local uiScale = UIScaleOperations.FindUIScale(wrapper.instance, "ScaleOnActivate")
	if not uiScale then return end

	local activated = not wrapper._toggles.ScaleOnActivate
	wrapper._toggles.ScaleOnActivate = activated
	uiScale.Scale = if activated then ACTIVE_SCALE else NORMAL_SCALE
end

local effect: Components.Effect = {
	Emit = emit,
}

return effect
