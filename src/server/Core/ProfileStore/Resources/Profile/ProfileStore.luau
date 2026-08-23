local charm = require("@RbxPackages/charm")
local Types = require("../../Data/Types")
local Profile = require("./Profile")

local getPlayerStore, setPlayerStore = charm.signal({} :: { [string]: Profile.IProfile })

local store = {
	Get = getPlayerStore,
	Set = setPlayerStore,
}

return store :: Types.IStore<Profile.IProfile>
