--!strict
local Helpers = require("../Helpers")
local TypedAggregates = require("../../Types/TypedAggregates")

local ACTIVE_SCALE = 1.5
local NORMAL_SCALE = 1

local ScaleOnActivate = {}
ScaleOnActivate.__index = ScaleOnActivate

export type ScaleOnActivate = typeof(setmetatable(
	{} :: { wrapper: TypedAggregates.IEffectHost, activated: boolean },
	ScaleOnActivate
))

function ScaleOnActivate.new(wrapper: TypedAggregates.IEffectHost): ScaleOnActivate
	return setmetatable({ wrapper = wrapper, activated = false }, ScaleOnActivate)
end

-- Каждый Emit переключает масштаб 1 <-> 1.5
function ScaleOnActivate.Emit(self: ScaleOnActivate)
	local uiScale = Helpers.FindUIScale(self.wrapper.instance, "ScaleOnActivate")
	if not uiScale then return end

	self.activated = not self.activated
	uiScale.Scale = if self.activated then ACTIVE_SCALE else NORMAL_SCALE
end

return ScaleOnActivate
