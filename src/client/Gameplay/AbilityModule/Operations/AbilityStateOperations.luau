local jecs = require("@RbxPackages/jecs")
local Abilities = require("@ClientInternal/Dependencies/Registries/Abilities")
local Components = require("../Data/Components")
local StateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local AbilityValidationOperations = require("./AbilityValidationOperations")
local ValidatorEnums = require("@SharedGameplay/AbilityModule/Data/ValidatorEnums")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.ExecuteStateBehavior(entity: jecs.Entity, owner: jecs.Entity, state: StateMachine.Phases)
	local abilityInfo = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	if not abilityInfo then return end

	local abilityName = abilityInfo.Name
	local selectedAbility = Abilities.Resource[abilityName]
	local defaultAbility = Abilities.Resource["Default"]

	if not selectedAbility then return end
	local selectedStateFunction = selectedAbility.Phases[state] or defaultAbility.Phases[state]

	local previousState = WorldPoint:get(entity, Components.PreviousState)
	-- ^ should probs be in the argument
	if previousState == state then return end
	WorldPoint:set(entity, Components.PreviousState, state)

	selectedStateFunction(entity)
end

-- ^ move this function somewhere else

function operations.StartAbility(entity: jecs.Entity, owner: jecs.Entity)
	if not AbilityValidationOperations.ValidateAbility(entity, owner, ValidatorEnums.Start) then return end
	WorldPoint:set(entity, Components.Shared.State, StateMachine.Phases.Charging)
end

function operations.StopAbility(entity: jecs.Entity, owner: jecs.Entity)
	if not AbilityValidationOperations.ValidateAbility(entity, owner, ValidatorEnums.Stop) then return end
	WorldPoint:set(entity, Components.Shared.State, StateMachine.Phases.Stoping)
end

function operations.CancelAbility(entity: jecs.Entity, owner: jecs.Entity)
	if not AbilityValidationOperations.ValidateAbility(entity, owner, ValidatorEnums.Interrupt) then return end
	WorldPoint:set(entity, Components.Shared.State, StateMachine.Phases.Interrupted)
end

return operations
