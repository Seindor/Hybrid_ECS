local store = require("./DocumentStore")

local Profile = require("../Data/Profile")

local operations = {}

function operations.Load(id: string): { success: boolean, data: Profile.IProfile?, reason: string? }
	local document = store:GetDocument(id)
	local result = document:Open()

	if not result.success and result.reason == "SessionLockedError" then
		document:Steal()
		result = document:Open()
	end

	if not result.success then return {
		reason = result.reason :: string,
		success = false,
	} end

	return {
		data = result.data,
		success = true,
	}
end

function operations.Save(id: string, data: Profile.IProfile)
	local document = store:GetDocument(id)

	if not document:IsOpen() then
		local result = document:Open()

		if not result.success then return end
	end

	document:SetCache(data)
end

function operations.Unload(id: string)
	local document = store:GetDocument(id)
	if document:IsOpen() then document:Close() end
end

function operations.Get(id: string): Profile.IProfile?
	local document = store:GetDocument(id)
	if document:IsOpen() then return document:GetCache() end

	return nil
end

return operations
