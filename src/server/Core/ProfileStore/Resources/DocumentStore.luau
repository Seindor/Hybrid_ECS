local DataStoreService = game:GetService("DataStoreService")

local documentservice = require("@RbxPackages/documentservice")
local Profile = require("../Data/Profile")

local store = documentservice.DocumentStore.new({
	dataStore = DataStoreService:GetDataStore("Main") :: any,
	check = function(data)
		return true, data :: Profile.IProfile
	end,
	default = Profile,
	migrations = {},
	lockSessions = true,
})

return store
