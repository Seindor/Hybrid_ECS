local jecs = require("@RbxPackages/jecs")
local Rounds = require("@ServerInternal/Dependencies/Registries/MatchRounds")
local Components = require("../Data/Components")
local StateMachine = require("@SharedGameplay/MatchModule/Data/RoundStateMachine")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

local function canChangeToNextPhase(currentPhase: StateMachine.Phases, predictedPhase: StateMachine.Phases): boolean
	return currentPhase == predictedPhase
end

local function executePhaseBehavior(entity: jecs.Entity)
	local currentPhase = WorldPoint:get(entity, Components.Shared.RoundState)
	if not currentPhase then return end

	local roundInfo = WorldPoint:get(entity, Components.Shared.RoundInfo)
	if not roundInfo then return end

	local selectedRound = Rounds.Resource[roundInfo.Name]
	if not selectedRound then return end

	local selectedPhaseBehavior = selectedRound.Phases[currentPhase]
	if not selectedPhaseBehavior then return end

	selectedPhaseBehavior(entity)
end

local function changeToNextPhase(entity: jecs.Entity, predictedPhase: StateMachine.Phases)
	local currentPhase = WorldPoint:get(entity, Components.Shared.RoundState)
	if not currentPhase then return end

	if not canChangeToNextPhase(currentPhase, predictedPhase) then return end

	local nextPhase = StateMachine.Transitions[predictedPhase]
	local selectedOperation = operations[nextPhase]

	if not nextPhase or not selectedOperation then return end

	WorldPoint:set(entity, Components.Shared.RoundState, nextPhase)
	selectedOperation(entity)
end

operations[StateMachine.Phases.OnStart] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.OnBattle)
end

operations[StateMachine.Phases.OnBattle] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.OnEnd)
end

return operations
