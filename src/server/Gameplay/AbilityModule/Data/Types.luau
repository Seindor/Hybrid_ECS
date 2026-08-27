local jecs = require("@RbxPackages/jecs")

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
