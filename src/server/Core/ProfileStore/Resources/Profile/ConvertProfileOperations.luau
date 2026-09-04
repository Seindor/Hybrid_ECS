local jecs = require("@RbxPackages/jecs")
local _WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Profile = require("./Profile")

local operations = {}

function operations.ConvertToStore(_entity: jecs.Entity)
	local profile: Profile.IProfile = {
		Test = 5,
	}

	return profile
end

function operations.ConvertFromStore(_entity: jecs.Entity, _data: Profile.IProfile) end

return operations
