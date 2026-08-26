local jecs = require("@RbxPackages/jecs")
local StateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local ValidatorEnums = require("../Data/ValidatorEnums")
local AbilityFSM = require("../Resources/AbilityFSM")
local AbilityValidationOperations = require("./AbilityValidationOperations")

local operations = {}

local function clearThreads(entity: jecs.Entity)
	local _internal = WorldPoint:get(entity, Components._abilityInternal)
	if not _internal then return end

	_internal.janitor:Cleanup()
end

local function stratThread(entity: jecs.Entity, phase: StateMachine.Phases)
	local _internal = WorldPoint:get(entity, Components._abilityInternal)
	if not _internal then return end

	clearThreads(entity)

	_internal.janitor:Add(task.spawn(function()
		WorldPoint:set(entity, Components.Shared.State, phase)
		AbilityFSM[phase](entity)
	end))
end

function operations.StartAbility(entity: jecs.Entity)
	if not AbilityValidationOperations.ValidateAbility(entity, ValidatorEnums.Start) then return end
	stratThread(entity, StateMachine.Phases.Charging)
end

function operations.StopAbility(entity: jecs.Entity)
	if not AbilityValidationOperations.ValidateAbility(entity, ValidatorEnums.Stop) then return end
	stratThread(entity, StateMachine.Phases.Stoping)
end

function operations.CancelAbility(entity: jecs.Entity)
	if not AbilityValidationOperations.ValidateAbility(entity, ValidatorEnums.Interrupt) then return end
	stratThread(entity, StateMachine.Phases.Interrupted)
end

return operations
