local jecs = require("@RbxPackages/jecs")
local ValidatorEnums = require("../Data/ValidatorEnums")
local Abilities = require("../Resources/Abilities")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.ValidateAbility(entity: jecs.Entity, validator: ValidatorEnums.Enums)
	local abilityName = WorldPoint:get(entity, Components.AbilityName)

	local selectedAbility = Abilities[abilityName or "Default"]
	if not selectedAbility then return end

	local selectedValidator = selectedAbility[validator]
	if not selectedValidator then return end

	return selectedValidator(entity)
end

return operations
