local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Interfaces = require("@SharedGameplay/StatusEffectModule/Data/Interfaces")
local Keys = require("@SharedGameplay/StatusEffectModule/Data/Keys")
local TimerAPI = require("@SharedGameplay/TimerModule/APIs/TimerAPI")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local StatusEffectsRegistry = require("../Resources/StatusEffectsRegistry")
local StatusEffectContainerOperations = require("./StatusEffectContainerOperations")
local StatusEffectConstructionOperations = require("./StatusEffectConstructionOperations")

local operations = {}

function operations.ExecuteBehavior(
	owner: jecs.Entity,
	effect: jecs.Entity,
	hook: keyof<Interfaces.IStatusEffectObject>,
	...
)
	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if not info then return end

	local behavior: any = StatusEffectsRegistry[info.name]
	assert(behavior, `{info.name} strategy is not registered in the status effects registry!`)

	local selectedHook = behavior[hook]
	if type(selectedHook) ~= "function" then return end

	selectedHook(owner, effect, ...)
end

function operations.ReapplyStatusEffect(owner: jecs.Entity, effect: jecs.Entity, data: { [string]: any }?)
	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if not info then return end

	local behavior = StatusEffectsRegistry[info.name]
	if behavior and type(behavior.OnReapply) == "function" then
		behavior.OnReapply(owner, effect, data)
		return
	end

	local stacks = WorldPoint:get(effect, Components.Shared.StatusEffectStacks) or 1
	WorldPoint:set(effect, Components.Shared.StatusEffectStacks, stacks + 1)

	info.data = sift.Dictionary.merge(info.data, data) :: { [string]: any }

	if not WorldPoint:has(effect, Components.Shared.StatusEffectPermanent) then
		local timers = WorldPoint:get(effect, Components.Shared.Timers)
		local durationTimer = timers and timers[Keys.DurationTimerKey]
		if durationTimer then TimerAPI.ResetTimer(durationTimer) end
	end

	WorldPoint:set(effect, Components.Shared.StatusEffectInfo, info)
end

local function DetachStatusEffect(owner: jecs.Entity, effect: jecs.Entity)
	operations.ExecuteBehavior(owner, effect, "OnRemove")

	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if info then StatusEffectContainerOperations.RemoveStatusEffectFromContainer(owner, info.name) end

	StatusEffectConstructionOperations.DestroyStatusEffect(effect)
end

function operations.HandleDoneTimers(owner: jecs.Entity, effect: jecs.Entity)
	local timers = WorldPoint:get(effect, Components.Shared.Timers)
	if not timers then return end

	for timerKey, timer in pairs(timers) do
		if not timer.done then continue end

		operations.ExecuteBehavior(owner, effect, "OnTimerDone", timerKey)

		if timerKey ~= Keys.DurationTimerKey then continue end
		operations.RemoveStatusEffect(owner, effect)
	end
end

function operations.RemoveStatusEffect(owner: jecs.Entity, effect: jecs.Entity)
	DetachStatusEffect(owner, effect)
end

return operations
