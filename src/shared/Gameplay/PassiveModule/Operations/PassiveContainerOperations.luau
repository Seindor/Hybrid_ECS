local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")

local operations = {}

function operations.HasPassive(owner: jecs.Entity, passiveName: string)
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return false end
	return passiveContainer[passiveName] ~= nil
end

function operations.GetPassive(owner: jecs.Entity, passiveName: string): Types.Passive?
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return nil end
	return passiveContainer[passiveName]
end

function operations.AddPassive(owner: jecs.Entity, passive: Types.Passive)
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return end
	passiveContainer[passive.name] = passive
end

function operations.RemovePassive(owner: jecs.Entity, passiveName: string)
	local passiveContainer = WorldPoint:get(owner, Components.PassiveContainer)
	if not passiveContainer then return end

	local selectedPassive = passiveContainer[passiveName]
	if selectedPassive then table.clear(selectedPassive) end

	passiveContainer[passiveName] = nil
end

return operations
