--!strict
local Animator = require(script.Parent.Parent.Animator)
local Easing = require(script.Parent.Parent.Easing)
local Helpers = require(script.Parent.Parent.Helpers)
local TypedAggregates = require(script.Parent.Parent.Parent.Types.TypedAggregates)
local UIWrapperTypes = require(script.Parent.Parent.Parent.Types.UIWrapperTypes)

local QUART = Enum.EasingStyle.Quart
local EASE_IN = Enum.EasingDirection.In
local EASE_OUT = Enum.EasingDirection.Out

local CurrencyPopupEffect = {}
CurrencyPopupEffect.__index = CurrencyPopupEffect

export type CurrencyPopupEffect = typeof(setmetatable({} :: { wrapper: TypedAggregates.IEffectHost }, CurrencyPopupEffect))

function CurrencyPopupEffect.new(wrapper: TypedAggregates.IEffectHost): CurrencyPopupEffect
	return setmetatable({ wrapper = wrapper }, CurrencyPopupEffect)
end

-- Позиция якоря target в масштабе родителя moving
local function getTargetPosition(moving: GuiObject, target: GuiObject, offset: UDim2?): UDim2?
	local parent = moving.Parent
	if not parent or not parent:IsA("GuiBase2d") then
		warn(`[UIWrapper] CurrencyPopupEffect: у {moving:GetFullName()} нет GUI-родителя`)
		return nil
	end

	local parentSize = parent.AbsoluteSize
	if parentSize.X == 0 or parentSize.Y == 0 then
		warn("[UIWrapper] CurrencyPopupEffect: у родителя нулевой размер")
		return nil
	end

	local relative = target.AbsolutePosition - parent.AbsolutePosition + target.AbsoluteSize * target.AnchorPoint
	local base = UDim2.fromScale(relative.X / parentSize.X, relative.Y / parentSize.Y)

	if offset then
		return base + offset
	end
	return base
end

function CurrencyPopupEffect.Emit(self: CurrencyPopupEffect, params: UIWrapperTypes.CurrencyPopupParams)
	local moving = self.wrapper.instance

	local uiScale = Helpers.FindUIScale(moving, "CurrencyPopupEffect")
	if not uiScale then
		return
	end

	local endPos = getTargetPosition(moving, params.target, params.offset)
	if not endPos then
		return
	end

	local bezierDuration = params.bezierDuration or 1
	local controlPos = params.controlPos or UDim2.fromScale(0.5, 0.2)
	local spawnScaleDuration = params.spawnScaleDuration or 0.1
	local fadeScaleStart = params.fadeScaleStart or 0.7

	local startPos = moving.Position

	-- Масштаб в момент времени: появление -> 1 -> схлопывание к концу полёта.
	-- (раньше после появления scale застревал на последнем значении easing, а не на 1)
	local function scaleAt(elapsed: number, progress: number): number
		local scale = 1

		if spawnScaleDuration > 0 and elapsed < spawnScaleDuration then
			scale = Easing.Ease(elapsed / spawnScaleDuration, QUART, EASE_OUT)
		end

		if fadeScaleStart < 1 and progress >= fadeScaleStart then
			local fadeProgress = (progress - fadeScaleStart) / (1 - fadeScaleStart)
			scale = math.min(scale, Easing.Ease(1 - fadeProgress, QUART, EASE_IN))
		end

		return scale
	end

	uiScale.Scale = 0

	Animator.Run(self.wrapper, "CurrencyPopupEffect", bezierDuration, function(progress, elapsed)
		local t = Easing.Ease(progress, QUART, EASE_IN)
		moving.Position = Easing.QuadraticBezierUDim2(startPos, controlPos, endPos, t)
		uiScale.Scale = scaleAt(elapsed, progress)
	end, function()
		uiScale.Scale = 0
		moving.Position = endPos
	end)
end

return CurrencyPopupEffect
