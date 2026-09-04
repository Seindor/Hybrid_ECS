local jecs = require("@RbxPackages/jecs")

export type PurchaseOperationRequestData = {
	name: string,
	data: any,
	reciever: jecs.Entity,
	sender: jecs.Entity,
	costs: { [string]: number }?,
}

export type IBehavior = {
	Validate: (request: jecs.Entity) -> boolean,
	Deduct: (request: jecs.Entity) -> (),
	Grant: (request: jecs.Entity) -> (),
}

return {}
