local immut = require("@RbxPackages/immut")
local Types = require("../Data/Types")

local adapter = {}
adapter.__index = adapter

local constructor = {}

type IAdapter<T> = Types.IStoreAdapter<T> & {
	Store: Types.IStore<T>,
}

function constructor.new<T>(store: Types.IStore<T>)
	local self = setmetatable({}, adapter)

	self.Store = store

	return self :: IAdapter<T>
end

function adapter.SaveToStore<T>(self: IAdapter<T>, id: string, data: T)
	local newStore = immut.produce(self.Store.Get(), function(draft)
		draft[id] = data
		return draft
	end)

	if not newStore then return end

	self.Store.Set(newStore)
end

function adapter.GetFromStore<T>(self: IAdapter<T>, id: string)
	return self.Store.Get()[id]
end

function adapter.RemoveFromStore<T>(self: IAdapter<T>, id: string)
	local newStore = immut.produce(self.Store.Get(), function(draft: { [string]: any })
		table.clear(draft[id] or {})
		draft[id] = nil
		return draft
	end)

	if not newStore then return end

	self.Store.Set(newStore)
end

return constructor
