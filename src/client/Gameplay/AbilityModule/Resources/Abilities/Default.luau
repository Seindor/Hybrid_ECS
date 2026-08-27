local StateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local Types = require("@SharedGameplay/AbilityModule/Data/Types")

local ability: Types.Ability = {
	Name = "Default",
	Phases = {},
}

ability.Phases[StateMachine.Phases.Charging] = function() end
ability.Phases[StateMachine.Phases.Starting] = function() end
ability.Phases[StateMachine.Phases.Active] = function() end
ability.Phases[StateMachine.Phases.Stoping] = function() end
ability.Phases[StateMachine.Phases.Recharging] = function() end
ability.Phases[StateMachine.Phases.Idle] = function() end
ability.Phases[StateMachine.Phases.Interrupted] = function() end

return ability
