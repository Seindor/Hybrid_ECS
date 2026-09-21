local StateMachine = require("@SharedGameplay/MatchModule/Data/RoundStateMachine")
local Types = require("@SharedGameplay/MatchModule/Data/Types")

local round: Types.Round = {
	Name = "Default",
	Phases = {},
}

round.Phases[StateMachine.Phases.OnStart] = function() end
round.Phases[StateMachine.Phases.OnBattle] = function() end
round.Phases[StateMachine.Phases.OnEnd] = function() end

return round
