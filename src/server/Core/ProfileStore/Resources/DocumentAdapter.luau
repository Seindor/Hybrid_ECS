local documentservice = require("@RbxPackages/documentservice")
local Types = require("../Data/Types")

local constructor = {}

local adapter = {}
adapter.__index = adapter

function constructor.new<T>(store: documentservice.DocumentStore<T>)
	local self = setmetatable({}, adapter)

	self.Store = store

	return self :: IAdapter<T>
end

type IAdapter<T> = Types.IDatabaseAdapter<T> & { Store: documentservice.DocumentStore<T> }

function adapter.Load<T>(self: IAdapter<T>, id: string): { success: boolean, data: T?, reason: string? }
	local document = self.Store:GetDocument(id)
	local result = document:Open()

	if not result.success and result.reason == "SessionLockedError" then
		document:Steal()
		result = document:Open()
	end

	if not result.success then return {
		reason = result.reason,
		success = false,
	} end

	return {
		data = result.data,
		success = true,
	}
end

function adapter.Save<T>(self: IAdapter<T>, id: string, data: T)
	local document = self.Store:GetDocument(id)

	if not document:IsOpen() then
		local result = document:Open()

		if not result.success then return end
	end

	document:SetCache(data)
end

function adapter.Unload<T>(self: IAdapter<T>, id: string)
	local document = self.Store:GetDocument(id)
	if document:IsOpen() then document:Close() end
end

function adapter.Get<T>(self: IAdapter<T>, id: string): T?
	local document = self.Store:GetDocument(id)
	if document:IsOpen() then return document:GetCache() end

	return nil
end

return constructor
