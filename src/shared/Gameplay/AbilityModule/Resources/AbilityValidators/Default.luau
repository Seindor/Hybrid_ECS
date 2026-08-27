local jecs = require("@RbxPackages/jecs")
local Types = require("../../Data/Types")
local StartValidators = require("../DefaultValidators/StartValidators")
local ValidatorEnums = require("../../Data/ValidatorEnums")

local ability: Types.AbilityValidators = {
	Name = "Default",
	Validators = {},
}

ability.Validators[ValidatorEnums.Start] = function(entity: jecs.Entity, owner: jecs.Entity)
	for _, validator in pairs(StartValidators) do
		if not validator(entity, owner) then return false end
	end
	return true
end

ability.Validators[ValidatorEnums.Stop] = function(entity: jecs.Entity)
	return true
end

ability.Validators[ValidatorEnums.Interrupt] = function(entity: jecs.Entity)
	return true
end

return ability
