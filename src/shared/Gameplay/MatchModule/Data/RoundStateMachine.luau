local phases = {
	OnStart = "OnStart",
	OnBattle = "OnBattle",
	OnEnd = "OnEnd",
}

local transitions = {
	[phases.OnStart] = phases.OnStart,
	[phases.OnBattle] = phases.OnBattle,
	[phases.OnEnd] = phases.OnEnd,
}

export type Phases = string --keyof<typeof(phases)>

return {
	Phases = phases,
	Transitions = transitions,
}
