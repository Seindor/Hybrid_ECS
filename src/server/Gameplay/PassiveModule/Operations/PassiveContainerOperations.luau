local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.HasPassive(owner: jecs.Entity, passiveName: string): boolean
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return false end
	return passiveContainer[passiveName] ~= nil
end

function operations.GetPassive(owner: jecs.Entity, passiveName: string): jecs.Entity?
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return nil end
	return passiveContainer[passiveName]
end

function operations.AddPassive(owner: jecs.Entity, passive: jecs.Entity): boolean
	local passiveContainer: { [string]: jecs.Entity } = WorldPoint:get(owner, Components.PassiveContainer) or {}
	local info = WorldPoint:get(passive, Components.PassiveInfo)
	if not info then return false end

	passiveContainer[info.name] = passive
	WorldPoint:set(owner, Components.PassiveContainer, passiveContainer)
	return true
end

function operations.RemovePassive(owner: jecs.Entity, passiveName: string): jecs.Entity?
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return nil end

	local passive = passiveContainer[passiveName]
	passiveContainer[passiveName] = nil
	WorldPoint:set(owner, Components.PassiveContainer, passiveContainer)
	return passive
end

return operations