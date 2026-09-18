local jecs = require("@RbxPackages/jecs")

export type ApplyStatusEffectRequestData = {
	owner: jecs.Entity,
	effectName: string,
	duration: number?,
	data: { [string]: any }?,
}

export type RemoveStatusEffectRequestData = {
	owner: jecs.Entity,
	effectName: string,
}

export type ReplicateStatusEffectRequestData = {
	owner: jecs.Entity,
	effectName: string,
	players: { [Player]: boolean }?,
}

return {}