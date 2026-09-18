local TimerTypes = require("@SharedGameplay/TimerModule/Data/Types")

export type StatusEffectInfo = {
	name: string,
	data: { [string]: any },
}

export type StatusEffectTimers = {
	[string]: TimerTypes.Timer,
}

return {}