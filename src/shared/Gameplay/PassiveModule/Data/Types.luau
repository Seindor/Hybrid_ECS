local jecs = require("@RbxPackages/jecs")

export type PassiveInfo = {
	name: string,
	data: { [string]: any },
}

export type IPassiveObject = {
	OnAttach: (owner: jecs.Entity, passive: jecs.Entity) -> (),
	OnDetach: (owner: jecs.Entity, passive: jecs.Entity) -> (),
	OnTick: (owner: jecs.Entity, passive: jecs.Entity) -> (),
}

return {}