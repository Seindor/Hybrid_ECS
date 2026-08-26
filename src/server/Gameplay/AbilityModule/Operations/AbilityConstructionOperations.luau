local janitor = require("@RbxPackages/janitor")
local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Components = require("../Data/Components")
local AbilityInfo = require("@SharedContent/Info/AbilityInfo")
local AbilityStateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")

local operations = {}

function operations.CreateAbility(data: Types.CreateAbilityRequestData): jecs.Entity?
	local abilityInfo = AbilityInfo[data.abilityName]
	if not abilityInfo then return nil end

	local entity = WorldPoint:entity()

	WorldPoint:set(entity, Components.AbilityInfo, sift.Dictionary.copyDeep(abilityInfo))
	WorldPoint:set(entity, Components._abilityInternal, {
		janitor = janitor.new(),
	})
	WorldPoint:set(entity, Components.Shared.State, AbilityStateMachine.Phases.Idle)
	WorldPoint:set(entity, Components.Cooldown, { passed = 0 })

	return entity
end

function operations.DestroyAbility(ability: jecs.Entity)
	WorldPoint:delete(ability)
end

return operations
