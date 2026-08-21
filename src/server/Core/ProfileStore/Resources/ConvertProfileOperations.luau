local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("@SharedInternal/Replication/Components")
local Profile = require("../Data/Profile")

local operations = {}

function operations.ConvertToStore(entity: jecs.Entity)
	local test = WorldPoint:get(entity, Components.TestComponent) or { Health = 5 }

	local profile: Profile.IProfile = {
		Test = test.Health,
	}

	return profile
end

function operations.ConvertFromStore(entity: jecs.Entity, data: Profile.IProfile)
	WorldPoint:set(entity, Components.TestComponent, { Health = data.Test })
end

return operations
