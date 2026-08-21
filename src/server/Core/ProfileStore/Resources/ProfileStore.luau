local charm = require("@RbxPackages/charm")
local Profile = require("../Data/Profile")

export type IProfileStore = { [string]: Profile.IProfile }

local getPlayerStore, setPlayerStore = charm.signal({} :: IProfileStore)

return {
	getPlayerStore = getPlayerStore,
	setPlayerStore = setPlayerStore,
}
