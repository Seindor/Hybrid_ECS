local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Types = require("../Data/Types")
local Keys = require("@SharedGameplay/StatusEffectModule/Data/Keys")
local SharedTypes = require("@SharedGameplay/StatusEffectModule/Data/Types")
local StatusEffectInfoTable = require("@SharedContent/Info/StatusEffectInfo")
local TimerAPI = require("@SharedGameplay/TimerModule/APIs/TimerAPI")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.CreateStatusEffect(data: Types.ApplyStatusEffectRequestData): jecs.Entity?
	local definition = StatusEffectInfoTable[data.effectName]
	if not definition then return nil end

	local duration = data.duration or definition.duration

	local entity = WorldPoint:entity()

	local info: SharedTypes.StatusEffectInfo = {
		name = data.effectName,
		data = sift.Dictionary.merge(definition.defaultData, data.data) :: { [string]: any },
	}

	WorldPoint:set(entity, Components.Shared.StatusEffectInfo, info)
	WorldPoint:set(entity, Components.Shared.StatusEffectOwner, data.owner)
	WorldPoint:set(entity, Components.Shared.StatusEffectStacks, 1)

	local timers: SharedTypes.StatusEffectTimers = {}
	if duration then
		timers[Keys.DurationTimerKey] = TimerAPI.CreateTimer(duration)
	else
		WorldPoint:add(entity, Components.Shared.StatusEffectPermanent)
	end

	WorldPoint:set(entity, Components.Shared.Timers, timers)

	return entity
end

function operations.DestroyStatusEffect(effect: jecs.Entity)
	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if info then table.clear(info) end
	WorldPoint:delete(effect)
end

return operations
