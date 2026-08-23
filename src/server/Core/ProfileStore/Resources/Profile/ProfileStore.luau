local charm = require("@RbxPackages/charm")
local Profile = require("./Profile")

export type IProfileStore = { [string]: Profile.IProfile }

local getPlayerStore, setPlayerStore = charm.signal({} :: IProfileStore)

return {
	Get = getPlayerStore,
	Set = setPlayerStore,
}
