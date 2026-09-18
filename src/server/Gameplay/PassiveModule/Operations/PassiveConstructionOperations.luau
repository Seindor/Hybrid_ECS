local jecs = require("@RbxPackages/jecs")
local SharedTypes = require("@SharedGameplay/PassiveModule/Data/Types")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.CreateContainer(owner: jecs.Entity)
	local passiveContainer: { [string]: jecs.Entity } = WorldPoint:get(owner, Components.PassiveContainer) or {}
	WorldPoint:set(owner, Components.PassiveContainer, passiveContainer)
end

function operations.CreatePassive(owner: jecs.Entity, name: string, data: { [string]: any }?): jecs.Entity?
	local entity = WorldPoint:entity()

	local info: SharedTypes.PassiveInfo = {
		name = name,
		data = data or {},
	}

	WorldPoint:set(entity, Components.PassiveInfo, info)
	WorldPoint:set(entity, Components.PassiveOwner, owner)

	return entity
end

function operations.DestroyPassive(passive: jecs.Entity)
	local info = WorldPoint:get(passive, Components.PassiveInfo)
	if info then table.clear(info) end
	WorldPoint:delete(passive)
end

return operations