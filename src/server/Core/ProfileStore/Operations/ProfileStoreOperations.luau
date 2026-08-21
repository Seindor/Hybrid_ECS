local immut = require("@RbxPackages/immut")
local Profile = require("../Data/Profile")
local ProfileStore = require("../Resources/ProfileStore")

local operations = {}

function operations.SaveToStore(id: string, data: Profile.IProfile)
	local newStore = immut.produce(ProfileStore.getPlayerStore(), function(draft)
		draft[id] = data
		return draft
	end)

	if not newStore then return end

	ProfileStore.setPlayerStore(newStore)
end

function operations.GetFromStore(id: string)
	return ProfileStore.getPlayerStore()[id]
end

function operations.RemoveFromStore(id: string)
	local newStore = immut.produce(ProfileStore.getPlayerStore(), function(draft: ProfileStore.IProfileStore)
		table.clear(draft[id] or {})
		draft[id] = nil
		return draft
	end)

	if not newStore then return end

	ProfileStore.setPlayerStore(newStore)
end

return operations
