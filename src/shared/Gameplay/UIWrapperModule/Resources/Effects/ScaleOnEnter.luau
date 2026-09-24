--!strict
--[[
	Пассивный эффект: вешает колбэки на MouseEnter/MouseLeave (идемпотентно, id фиксированные).
]]

local Components = require("../../Data/Components")
local UIScaleOperations = require("../../Operations/UIScaleOperations")
local WrapperCallbacksOperations = require("../../Operations/WrapperCallbacksOperations")

local HOVER_SCALE = 1.035
local NORMAL_SCALE = 1

local function apply(wrapper: Components.WrapperState)
	local uiScale = UIScaleOperations.FindUIScale(wrapper.instance, "ScaleOnEnter")
	if not uiScale then return end

	WrapperCallbacksOperations.AddCallback(wrapper, "MouseEnter", "ScaleOnEnter", function()
		wrapper.miscData.ScaleOnEnter = HOVER_SCALE
		uiScale.Scale = HOVER_SCALE
	end)

	WrapperCallbacksOperations.AddCallback(wrapper, "MouseLeave", "ScaleOnLeave", function()
		wrapper.miscData.ScaleOnEnter = NORMAL_SCALE
		uiScale.Scale = NORMAL_SCALE
	end)
end

local effect: Components.Effect = {
	Emit = apply,
	Apply = apply,
}

return effect
