local Interfaces = require("@SharedGameplay/StatusEffectModule/Data/Interfaces")
local StatusEffectInfoTable = require("@SharedContent/Info/StatusEffectInfo")
local TimerTypes = require("@SharedGameplay/TimerModule/Data/Types")
local TimerAPI = require("@SharedGameplay/TimerModule/APIs/TimerAPI")
local Components = require("../../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local poison = {} :: Interfaces.IStatusEffectObject

local TICK_TIMER_KEY = "Tick"

function poison.OnApply(_owner, effect)
	local definition = StatusEffectInfoTable.Poison
	local timers: TimerTypes.TimerContainer = WorldPoint:get(effect, Components.Shared.Timers) or {}

	timers[TICK_TIMER_KEY] = TimerAPI.CreateTimer(definition.tickInterval or 1)

	WorldPoint:set(effect, Components.Shared.Timers, timers)
end

function poison.OnTimerDone(_owner, effect, timerKey)
	if timerKey ~= TICK_TIMER_KEY then return end

	-- TODO: apply damage through a damage pipeline once one exists
	print("Poison damage tick")

	local timers = WorldPoint:get(effect, Components.Shared.Timers)
	if not timers then return end
	TimerAPI.ResetTimer(timers[TICK_TIMER_KEY])
end

return poison