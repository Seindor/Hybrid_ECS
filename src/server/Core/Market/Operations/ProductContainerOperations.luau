local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")
local operations = {}

function operations.AddProductToContainer(owner: jecs.Entity, product: Types.Product)
	local container = WorldPoint:get(owner, Components.ProductContainer)
	if not container then return end
	container[product.productId] = product
end

function operations.GetProductFromContainer(owner: jecs.Entity, id: string): Types.Product?
	local container = WorldPoint:get(owner, Components.ProductContainer)
	if not container then return nil end
	return container[id]
end

function operations.RemoveProductFromContainer(owner: jecs.Entity, id: string)
	local container = WorldPoint:get(owner, Components.ProductContainer)
	if not container then return end
	container[id] = nil
end

return operations
