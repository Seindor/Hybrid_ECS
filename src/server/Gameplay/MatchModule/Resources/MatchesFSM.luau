local jecs = require("@RbxPackages/jecs")
local Matches = require("@ServerInternal/Dependencies/Registries/Matches")
local Components = require("../Data/Components")
local StateMachine = require("@SharedGameplay/MatchModule/Data/MatchStateMachine")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

local function canChangeToNextPhase(currentPhase: StateMachine.Phases, predictedPhase: StateMachine.Phases): boolean
	return currentPhase == predictedPhase
end

local function executePhaseBehavior(entity: jecs.Entity)
	local currentPhase = WorldPoint:get(entity, Components.Shared.MatchState)
	if not currentPhase then return end

	local matchInfo = WorldPoint:get(entity, Components.Shared.MatchInfo)
	if not matchInfo then return end

	local selectedMatche = Matches.Resource[matchInfo.Name]
	if not selectedMatche then return end

	local selectedPhaseBehavior = selectedMatche.Phases[currentPhase]
	if not selectedPhaseBehavior then return end

	selectedPhaseBehavior(entity)
end

local function changeToNextPhase(entity: jecs.Entity, predictedPhase: StateMachine.Phases)
	local currentPhase = WorldPoint:get(entity, Components.Shared.MatchState)
	if not currentPhase then return end

	if not canChangeToNextPhase(currentPhase, predictedPhase) then return end

	local nextPhase = StateMachine.Transitions[predictedPhase]
	local selectedOperation = operations[nextPhase]

	if not nextPhase or not selectedOperation then return end

	WorldPoint:set(entity, Components.Shared.MatchState, nextPhase)
	selectedOperation(entity)
end

operations[StateMachine.Phases.OnPick] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.OnStart)
end

operations[StateMachine.Phases.OnStart] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.OnBattle)
end

operations[StateMachine.Phases.OnBattle] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.OnEnd)
end

operations[StateMachine.Phases.OnEnd] = function(entity: jecs.Entity)
	executePhaseBehavior(entity)
	changeToNextPhase(entity, StateMachine.Phases.OnDelete)
end

return operations
