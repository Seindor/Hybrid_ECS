local jecs = require("@RbxPackages/jecs")

export type IStatusEffectObject = {
	OnApply: ((owner: jecs.Entity, effect: jecs.Entity) -> ())?,
	OnTick: ((owner: jecs.Entity, effect: jecs.Entity) -> ())?,
	OnReapply: ((owner: jecs.Entity, effect: jecs.Entity, data: { [string]: any }?) -> ())?,
	OnTimerDone: ((owner: jecs.Entity, effect: jecs.Entity, timerKey: string) -> ())?,
	OnRemove: ((owner: jecs.Entity, effect: jecs.Entity) -> ())?,
}

return {}