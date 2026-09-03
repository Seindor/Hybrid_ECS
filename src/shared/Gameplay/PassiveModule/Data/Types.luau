local jecs = require("@RbxPackages/jecs")

export type Passive = {
	name: string,
	additional: { [string]: any },
}

export type IPassiveObject = {
	OnAttach: (owner: jecs.Entity, passive: Passive) -> (),
	OnDetach: (owner: jecs.Entity, passive: Passive) -> (),
	OnTick: (owner: jecs.Entity, passive: Passive) -> (),
}

-- ^ due to the fact that we have to define types of other module requests in the passive module
-- we can accept the fact that passive module will have systems which reference other modules

-- ^ arguments in said methods may also include additional info of the operation, which needs to be strictly typed
-- instead of using additional {[string]: any}

-- ^ said events cannot be strictly defined in the interface, instead should be flexible enough so that they could change
-- from project to project

-- ^ passives and buffs with limited time effects should be separated into 2 different modules

return {}
