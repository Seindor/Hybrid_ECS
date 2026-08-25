local jecs = require("@RbxPackages/jecs")
local Abilities = require("./Abilities")
local Components = require("../Data/Components")
local StateMachine = require("@ServerGameplay/AbilityModule/Data/StateMachine")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

local function canChangeToNextPhase(
	entity: jecs.Entity,
	currentPhase: StateMachine.Phases,
	predictedPhase: StateMachine.Phases
): boolean
	return currentPhase ~= predictedPhase
end

local function executePhaseBehavior(entity: jecs.Entity)
	local currentPhase = WorldPoint:get(entity, Components.State)
	if not currentPhase then return end

	local abilityName = WorldPoint:get(entity, Components.AbilityName)

	local selectedAbility = Abilities[abilityName or "Default"]
	if not selectedAbility then return end

	local selectedPhaseBehavior = selectedAbility[currentPhase]
	if not selectedPhaseBehavior then return end

	selectedPhaseBehavior(entity)
end

local function changeToNextPhase(entity: jecs.Entity, predictedPhase: StateMachine.Phases)
	local currentPhase = WorldPoint:get(entity, Components.State)
	if not currentPhase then return end
	if not canChangeToNextPhase(entity, currentPhase, predictedPhase) then return end

	local nextPhase = StateMachine.Transitions[predictedPhase]
	local selectedOperation = operations[nextPhase]

	if not selectedOperation then return end
	selectedOperation(entity)
end

operations[StateMachine.Phases.Charging] = function(entity: jecs.Entity)
	WorldPoint:add(entity, Components.Active)

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
	WorldPoint:remove(entity, Components.OnCD)

	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Idle)
end

operations[StateMachine.Phases.Recharging] = function(entity: jecs.Entity)
	WorldPoint:remove(entity, Components.Active)
	WorldPoint:add(entity, Components.OnCD)
	WorldPoint:set(entity, Components.Cooldown, { passed = 0 })

	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Recharging)
end

operations[StateMachine.Phases.Interrupted] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.Interrupted)
end

return operations
