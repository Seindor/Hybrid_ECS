local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local validators: { [string]: (...any) -> () } = {}

function validators.CheckCD(ability: jecs.Entity): boolean
	local onCD = WorldPoint:has(ability, Components.Shared.OnCD)
	return not onCD
end

function validators.CheckActive(ability: jecs.Entity): boolean
	local active = WorldPoint:has(ability, Components.Shared.Active)
	return not active
end

function validators.CheckOwnerActiveAbility(ability: jecs.Entity)
	local owner = WorldPoint:get(ability, Components.AbilityOwner)
	if not owner then return true end

	local usingAbility = WorldPoint:has(owner, Components.Shared.UsingAbility)
	return not usingAbility
end

return validators
