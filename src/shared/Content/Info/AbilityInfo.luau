local AbilityType = require("../Types/AbilityType")

local info: { [string]: AbilityType.Ability } = {}

info["Test"] = {
	Name = "Test",
	CD = 5,
	Damage = 10,
}

return info
