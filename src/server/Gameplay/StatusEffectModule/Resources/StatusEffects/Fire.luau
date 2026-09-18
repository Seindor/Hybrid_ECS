local Interfaces = require("@SharedGameplay/StatusEffectModule/Data/Interfaces")
local StatusEffectInfoTable = require("@SharedContent/Info/StatusEffectInfo")
local TimerTypes = require("@SharedGameplay/TimerModule/Data/Types")
local TimerAPI = require("@SharedGameplay/TimerModule/APIs/TimerAPI")
local Components = require("../../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local fire = {} :: Interfaces.IStatusEffectObject

local TICK_TIMER_KEY = "Tick"

function fire.OnApply(_owner, effect)
	local definition = StatusEffectInfoTable.Fire
	local timers: TimerTypes.TimerContainer = WorldPoint:get(effect, Components.Shared.Timers) or {}

	timers[TICK_TIMER_KEY] = TimerAPI.CreateTimer(definition.tickInterval or 1)

	WorldPoint:set(effect, Components.Shared.Timers, timers)
end

function fire.OnTimerDone(_owner, effect, timerKey)
	if timerKey ~= TICK_TIMER_KEY then return end

	-- TODO: apply damage through a damage pipeline once one exists
	print("Fire damage tick")

	local timers = WorldPoint:get(effect, Components.Shared.Timers)
	if not timers then return end
	TimerAPI.ResetTimer(timers[TICK_TIMER_KEY])
end

return fire