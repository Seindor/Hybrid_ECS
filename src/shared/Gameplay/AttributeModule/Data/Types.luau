export type Attribute = {
	baseValue: number,
	value: number,
	tags: { string },
	calculator: string,
}

export type Modifier = {
	tags: { string },
	additional: { [string]: any },
	behavior: string,
}

export type ActionContext = { [string]: any }

export type IBehavior = {
	Check: (context: { [string]: any }, attribute: Attribute, modifier: Modifier) -> boolean,
	Apply: (context: { [string]: any }, attribute: Attribute, modifier: Modifier) -> Attribute,
}

export type ICalculator = {
	Apply: (context: { [string]: any }, attribute: Attribute) -> Attribute,
}

return {}
