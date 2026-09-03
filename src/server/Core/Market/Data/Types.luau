export type PurchaseItemRequest = {
	purchaserId: string,
	productId: string,
	recieverId: string?,
}

export type Product = {
	productId: string,
	name: string,
}

export type ProductInfo = {
	name: string,
	productId: string,
	productType: any, -- < change later to a proper Marketplace enum type
	oneTimePurchase: boolean,
}
-- ^ move to content info

-- ^ how should we specify rewards or any reward related action using data driven design?
-- market module should be unaware of rewards

-- ^ by making them not depend on each other we have the ability to bound different logic to the same reward

--[[

somehow we need to make store module responsible for giving out various rewards
that way we can give out rewards no matter the purchase method

how can we plan store module in such case?
we would need a separate module which would be responsible for giving out rewards

data template needs to be unique for each case


]]

export type Cost = {
	currencies: {
		[string]: number,
	},
}

export type Item = {
	name: string,
	avaliableCosts: { Cost },
}

export type PurchaseOperation = {
	item: Item, --rename (data?)
	cost: Cost,
	handler: string,
}

--[[

purchase client request
server listens
creates server purchase request
system processes it
calls validation (drops the request if it doesnt pass)
^ get product info via content + DI?
creates PromptProductPurchase request
server listens for ProcessReceipt
validates request based on retrieved data
gets selected behavior from ProductBehaviorRegistry
activates said behavior
activates post behavior callback

]]

return {}
