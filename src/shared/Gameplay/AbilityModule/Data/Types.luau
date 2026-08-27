local jecs = require("@RbxPackages/jecs")
local ValidatorEnums = require("./ValidatorEnums")
local AbilityStateMachine = require("./AbilityStateMachine")

export type Ability = {
	Name: string, -- should swap for Enums?
	Phases: { [AbilityStateMachine.Phases]: (jecs.Entity) -> () },
}

export type AbilityValidators = {
	Name: string?,
	Validators: { [ValidatorEnums.Enums]: (ability: jecs.Entity, owner: jecs.Entity) -> boolean },
}

return {}
