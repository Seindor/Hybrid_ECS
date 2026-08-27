local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../../Data/Components")

local validators: { [string]: (...any) -> () } = {}

function validators.CheckCD(ability: jecs.Entity): boolean
	local onCD = WorldPoint:has(ability, Components.OnCD)
	return not onCD
end

function validators.CheckActive(ability: jecs.Entity): boolean
	local active = WorldPoint:has(ability, Components.Active)
	return not active
end

function validators.CheckOwnerActiveAbility(ability: jecs.Entity, owner: jecs.Entity)
	local usingAbility = WorldPoint:has(owner, Components.UsingAbility)
	return not usingAbility
end

return validators
