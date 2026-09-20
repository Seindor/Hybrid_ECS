--!strict

local Helpers = require("../Helpers")
local TypedAggregates = require("../../Types/TypedAggregates")

local HOVER_SCALE = 1.035
local NORMAL_SCALE = 1

local ScaleOnEnter = {}
ScaleOnEnter.__index = ScaleOnEnter

export type ScaleOnEnter = typeof(setmetatable({} :: { wrapper: TypedAggregates.IEffectHost }, ScaleOnEnter))

function ScaleOnEnter.new(wrapper: TypedAggregates.IEffectHost): ScaleOnEnter
	return setmetatable({ wrapper = wrapper }, ScaleOnEnter)
end

-- Пассивный эффект: вешает колбэки на MouseEnter/MouseLeave (идемпотентно, id фиксированные)
function ScaleOnEnter.Apply(self: ScaleOnEnter)
	local wrapper = self.wrapper

	local uiScale = Helpers.FindUIScale(wrapper.instance, "ScaleOnEnter")
	if not uiScale then
		return -- раньше тут был warn и последующее падение на nil
	end

	wrapper:AddCallback("MouseEnter", "ScaleOnEnter", function()
		wrapper.miscData.ScaleOnEnter = HOVER_SCALE
		uiScale.Scale = HOVER_SCALE
	end)

	wrapper:AddCallback("MouseLeave", "ScaleOnLeave", function()
		wrapper.miscData.ScaleOnEnter = NORMAL_SCALE
		uiScale.Scale = NORMAL_SCALE
	end)
end

function ScaleOnEnter.Emit(self: ScaleOnEnter)
	self:Apply()
end

return ScaleOnEnter
