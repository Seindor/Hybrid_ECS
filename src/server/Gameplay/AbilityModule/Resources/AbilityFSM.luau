local jecs = require("@RbxPackages/jecs")
local StateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local TimerAPI = require("@SharedGameplay/TimerModule/APIs/TimerAPI")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Abilities = require("@ServerInternal/Dependencies/Registries/Abilities")

local operations = {}

local function canChangeToNextPhase(currentPhase: StateMachine.Phases, predictedPhase: StateMachine.Phases): boolean
	return currentPhase == predictedPhase
end

local function executePhaseBehavior(entity: jecs.Entity)
	local currentPhase = WorldPoint:get(entity, Components.Shared.State)
	if not currentPhase then return end

	local abilityInfo = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	if not abilityInfo then return end

	local selectedAbility = Abilities.Resource[abilityInfo.Name]
	if not selectedAbility then return end

	local selectedPhaseBehavior = selectedAbility.Phases[currentPhase]
	if not selectedPhaseBehavior then return end

	selectedPhaseBehavior(entity)
end

local function changeToNextPhase(entity: jecs.Entity, predictedPhase: StateMachine.Phases)
	local currentPhase = WorldPoint:get(entity, Components.Shared.State)
	if not currentPhase then return end

	if not canChangeToNextPhase(currentPhase, predictedPhase) then return end

	local nextPhase = StateMachine.Transitions[predictedPhase]
	local selectedOperation = operations[nextPhase]

	if not nextPhase or not selectedOperation then return end

	WorldPoint:set(entity, Components.Shared.State, nextPhase)
	selectedOperation(entity)
end

operations[StateMachine.Phases.Charging] = function(entity: jecs.Entity)
	WorldPoint:add(entity, Components.Shared.Active)

	local owner = WorldPoint:get(entity, Components.Shared.AbilityOwner)
	if owner then WorldPoint:add(owner, Components.Shared.UsingAbility) end

	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Charging)
end

operations[StateMachine.Phases.Starting] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Starting)
end

operations[StateMachine.Phases.Active] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Active)
end

operations[StateMachine.Phases.Stoping] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Stoping)
end

operations[StateMachine.Phases.Idle] = function(entity: jecs.Entity)
	WorldPoint:remove(entity, Components.Shared.OnCD)

	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Idle)
end

operations[StateMachine.Phases.Recharging] = function(entity: jecs.Entity)
	local owner = WorldPoint:get(entity, Components.Shared.AbilityOwner)
	if owner then WorldPoint:remove(owner, Components.Shared.UsingAbility) end

	WorldPoint:remove(entity, Components.Shared.Active)
	WorldPoint:add(entity, Components.Shared.OnCD)

	-- maybe change it later?
	local abilityInfo = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	if not abilityInfo then return end

	local timers = WorldPoint:get(entity, Components.Shared.Timers)
	if not timers then return end

	executePhaseBehavior(entity)

	TimerAPI.StartTimer(timers.CD, abilityInfo.CD)
	TimerAPI.WaitForTimer(timers.CD)
	-- ^ should this logic be in FSM or in a separate phase behavior?

	changeToNextPhase(entity, StateMachine.Phases.Recharging)
end

operations[StateMachine.Phases.Interrupted] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Interrupted)
end

return operations
