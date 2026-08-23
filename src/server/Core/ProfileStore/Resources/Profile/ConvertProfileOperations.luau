local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Profile = require("./Profile")

local operations = {}

function operations.ConvertToStore(entity: jecs.Entity)
	local profile: Profile.IProfile = {
		Test = 5,
	}

	return profile
end

function operations.ConvertFromStore(entity: jecs.Entity, data: Profile.IProfile) end

return operations
