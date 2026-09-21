local StateMachine = require("@SharedGameplay/MatchModule/Data/MatchStateMachine")
local Types = require("@SharedGameplay/MatchModule/Data/Types")

local match: Types.Match = {
	Name = "Default",
	Phases = {},
}

match.Phases[StateMachine.Phases.OnPick] = function() end
match.Phases[StateMachine.Phases.OnStart] = function() end
match.Phases[StateMachine.Phases.OnBattle] = function() end
match.Phases[StateMachine.Phases.OnEnd] = function() end

return match
