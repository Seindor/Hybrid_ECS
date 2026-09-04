local jecs = require("@RbxPackages/jecs")

export type Passive = {
	name: string,
	additional: { [string]: any },
	active: boolean?,
}

export type IPassiveObject = {
	OnAttach: (owner: jecs.Entity, passive: Passive) -> (),
	OnDetach: (owner: jecs.Entity, passive: Passive) -> (),
	OnTick: (owner: jecs.Entity, passive: Passive) -> (),
}

return {}
