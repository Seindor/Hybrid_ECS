local phases = {
	OnPick = "OnPick",
	OnStart = "OnStart",
	OnBattle = "OnBattle",
	OnEnd = "OnEnd",
	OnDelete = "OnDelete",
}

local transitions = {
	[phases.OnPick] = phases.OnPick,
	[phases.OnStart] = phases.OnStart,
	[phases.OnBattle] = phases.OnBattle,
	[phases.OnEnd] = phases.OnEnd,
	[phases.OnDelete] = phases.OnDelete,
}

export type Phases = string --keyof<typeof(phases)>

return {
	Phases = phases,
	Transitions = transitions,
}
