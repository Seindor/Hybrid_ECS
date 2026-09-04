local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	PurchaseRequestData = WorldPoint:component() :: jecs.Component<Types.PurchaseOperationRequestData>,
	ValidationRequestData = WorldPoint:component() :: jecs.Component<Types.PurchaseOperationRequestData>,
}
