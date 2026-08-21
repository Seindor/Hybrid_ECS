local Profile = require("../Data/Profile")
local ProfileStoreOperations = require("./ProfileStoreOperations")
local DocumentOperations = require("../Resources/DocumentOperations")
-- ^ Inject with DI if needed

local operations = {}

function operations.Save(id: string, data: Profile.IProfile)
	ProfileStoreOperations.SaveToStore(id, data)
	DocumentOperations.Save(id, data)
end

function operations.Load(id: string): Profile.IProfile?
	local result = DocumentOperations.Load(id)
	local data = result.data

	if not data then return nil end

	ProfileStoreOperations.SaveToStore(id, data)

	return data
end

function operations.Unload(id: string)
	ProfileStoreOperations.RemoveFromStore(id)
	DocumentOperations.Unload(id)
end

function operations.Get(id: string)
	return ProfileStoreOperations.GetFromStore(id)
end

return operations
