local phases = {
	Charging = "Charging",
	Starting = "Starting",
	Active = "Active",
	Stoping = "Stoping",
	Recharging = "Recharging",
	Idle = "Idle",
	Interrupted = "Interrupted",
}

local transitions = {
	[phases.Charging] = phases.Starting,
	[phases.Starting] = phases.Active,
	[phases.Active] = phases.Stoping,
	[phases.Stoping] = phases.Recharging,
	[phases.Recharging] = phases.Idle,
	[phases.Interrupted] = phases.Recharging,
}

return {
	Phases = phases,
	Transitions = transitions,
}
