local Types = require("../Data/Types")

local service = {}
service.__index = service

local constructor = {}

type IService<T> = typeof(service) & {
	DatabaseAdapter: Types.IDatabaseAdapter<T>,
	StoreAdapter: Types.IStoreAdapter<T>,
}

export type Export = IService<any>

function constructor.new<T>(databaseAdapter: Types.IDatabaseAdapter<T>, storeAdapter: Types.IStoreAdapter<T>)
	local self = setmetatable({}, service)

	self.DatabaseAdapter = databaseAdapter
	self.StoreAdapter = storeAdapter

	return self :: IService<T>
end

function service.Save<T>(self: IService<T>, id: string, data: T)
	self.StoreAdapter:SaveToStore(id, data)
	self.DatabaseAdapter:Save(id, data)
end

function service.Load<T>(self: IService<T>, id: string): T?
	local result = self.DatabaseAdapter:Load(id)
	local data = result.data

	if not data then return nil end
	self.StoreAdapter:SaveToStore(id, data)

	return data
end

function service.Unload<T>(self: IService<T>, id: string)
	self.StoreAdapter:RemoveFromStore(id)
	self.DatabaseAdapter:Unload(id)
end

function service.Get<T>(self: IService<T>, id: string)
	return self.StoreAdapter:GetFromStore(id)
end

return service
