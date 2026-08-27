local jecs = require("@RbxPackages/jecs")
local AbilityStateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local ValidatorEnums = require("./ValidatorEnums")

export type IAbility = {
	Name: string, -- should swap for Enums?
	Phases: { [AbilityStateMachine.Phases]: (jecs.Entity) -> () },
	Validators: { [ValidatorEnums.Enums]: (jecs.Entity) -> boolean },
}

export type ReplicateAbilityRequestData = {
	owner: jecs.Entity,
	abilityName: string,
	players: { [Player]: boolean }?,
}

export type CreateAbilityRequestData = {
	owner: jecs.Entity,
	abilityName: string,
}

export type DestroyAbilityRequestData = {
	owner: jecs.Entity,
	abilityName: string,
}

return {}
