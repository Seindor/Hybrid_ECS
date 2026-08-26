local jecs = require("@RbxPackages/jecs")
local ValidatorEnums = require("../Data/ValidatorEnums")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local AbilitiesRegistry = require("../Resources/AbilitiesRegistry")

local operations = {}

function operations.ValidateAbility(entity: jecs.Entity, validator: ValidatorEnums.Enums): boolean?
	local abilityInfo = WorldPoint:get(entity, Components.AbilityInfo)
	if not abilityInfo then return false end

	local selectedAbility = AbilitiesRegistry[abilityInfo.Name]
	if not selectedAbility then return false end

	local selectedValidator = selectedAbility.Validators[validator]
	if not selectedValidator then selectedValidator = AbilitiesRegistry["Default"].Validators[validator] end

	return selectedValidator(entity)
end

return operations
