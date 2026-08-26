local jecs = require("@RbxPackages/jecs")
local StateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local DefaultStartValidators = require("../DefaultStartValidators")
local Types = require("../../Data/Types")
local ValidatorEnums = require("../../Data/ValidatorEnums")

local ability: Types.IAbility = {
	Phases = {},
	Validators = {},
}

ability.Phases[StateMachine.Phases.Charging] = function() end
ability.Phases[StateMachine.Phases.Starting] = function() end
ability.Phases[StateMachine.Phases.Active] = function() end
ability.Phases[StateMachine.Phases.Stoping] = function() end
ability.Phases[StateMachine.Phases.Recharging] = function() end
ability.Phases[StateMachine.Phases.Idle] = function() end
ability.Phases[StateMachine.Phases.Interrupted] = function() end

ability.Validators[ValidatorEnums.Start] = function(entity: jecs.Entity)
	for _, validator in pairs(DefaultStartValidators) do
		if not validator(entity) then return false end
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
