local jecs = require("@RbxPackages/jecs")
local Abilities = require("@ServerInternal/Dependencies/Registries/Abilities")
local ValidatorEnums = require("../Data/ValidatorEnums")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.ValidateAbility(entity: jecs.Entity, validator: ValidatorEnums.Enums): boolean?
	local abilityInfo = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	if not abilityInfo then return false end

	local selectedAbility = Abilities.Resource[abilityInfo.Name]
	if not selectedAbility then return false end

	local selectedValidator = selectedAbility.Validators[validator]
	if not selectedValidator then selectedValidator = Abilities.Resource["Default"].Validators[validator] end

	return selectedValidator(entity)
end

return operations
