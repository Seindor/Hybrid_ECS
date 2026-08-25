local jecs = require("@RbxPackages/jecs")
local ValidatorEnums = require("./ValidatorEnums")
local StateMachine = require("./StateMachine")

export type IAbility = {
	Phases: { [StateMachine.Phases]: (jecs.Entity) -> () },
	Validators: { [ValidatorEnums.Enums]: (jecs.Entity) -> boolean },
}

return {}
