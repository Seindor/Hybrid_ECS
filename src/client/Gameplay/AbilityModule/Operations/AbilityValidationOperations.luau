local jecs = require("@RbxPackages/jecs")
local ValidatorEnums = require("@SharedGameplay/AbilityModule/Data/ValidatorEnums")
local AbilityValidators = require("@SharedInternal/Dependencies/Registries/AbilityValidators")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Abilities = require("@ClientInternal/Dependencies/Registries/Abilities")

local operations = {}

function operations.ValidateAbility(entity: jecs.Entity, owner: jecs.Entity, validator: ValidatorEnums.Enums): boolean?
	local abilityInfo = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	if not abilityInfo then return false end

	local selectedAbility = Abilities.Resource[abilityInfo.Name]
	if not selectedAbility then return false end

	local validators = AbilityValidators.Resource[abilityInfo.Name]
	if not validators then validators = AbilityValidators.Resource["Default"] end

	local selectedValidator = validators.Validators[validator]
	if not selectedValidator then return false end

	return selectedValidator(entity, owner)
end

return operations
