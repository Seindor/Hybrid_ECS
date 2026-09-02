local jecs = require("@RbxPackages/jecs")

export type Attribute = {
	baseValue: number,
	value: number,
	calculator: string,
	_dirty: boolean?,
}

export type Modifier = {
	tags: { string },
	value: number,
}

export type ActionContext = {
	attribute: Attribute,
	owner: jecs.Entity,
	additional: { [string]: any },
	--^ used to store values between pipeline steps
}

export type ICalculator = {
	Calculate: (context: ActionContext) -> (),
}

return {}
