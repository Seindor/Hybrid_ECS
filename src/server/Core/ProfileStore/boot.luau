local App = require("@SharedCore/App/Services/App")
local Tokens = require("@ServerInternal/Dependencies/Tokens")
local ProfileStore = require("./Resources/Profile/ProfileStore")
local DocumentStore = require("./Resources/Profile/DocumentStore")
local StoreAdapter = require("./Resources/StoreAdapter")
local DocumentAdapter = require("./Resources/DocumentAdapter")
local DatastoreService = require("./Services/DatastoreService")
local ProfileSystem = require("./Systems/ProfileConversionSystem")

return function(app: App.IApp)
	local datastore = DocumentStore
	local statestore = ProfileStore

	local profileStatestoreAdapter = StoreAdapter.new(statestore)
	local profileDatastoreAdapter = DocumentAdapter.new(datastore)

	app:RegisterResource(
		Tokens.Datastores.Profile,
		DatastoreService.new(profileDatastoreAdapter, profileStatestoreAdapter)
	)

	task.spawn(function()
		while task.wait(10) do
			ProfileSystem.ConvertProfile()
		end
	end)
end
