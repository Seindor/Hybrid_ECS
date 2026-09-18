local StatusEffectType = require("../Types/StatusEffectType")

local info: { [string]: StatusEffectType.StatusEffectDefinition } = {}

info.Fire = {
	duration = 5,
	tickInterval = 1,
	defaultData = {
		dps = 10,
	},
}

info.Poison = {
	duration = 8,
	tickInterval = 2,
	defaultData = {
		dps = 5,
	},
}

info.TestAura = {
	defaultData = {
		range = 10,
	},
}

return info