local jecs = require("@RbxPackages/jecs")
local AbilityReplicationOperations = require("../Operations/AbilityReplicationOperations")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local AbilityStateOperations = require("../Operations/AbilityStateOperations")
local Types = require("../Data/Types")
local AbilityContainerOperations = require("../Operations/AbilityContainerOperations")
local AbilityRequestOperations = require("../Operations/AbilityRequestOperations")

local API = {}

function API.CreateAbility(data: Types.CreateAbilityRequestData)
	AbilityRequestOperations.RequestAbilityCreation(data)
end

function API.ReplicateAbility(owner: jecs.Entity, abilityName: string, players: { [Player]: boolean })
	AbilityReplicationOperations.AddAbilityReplication({ owner = owner, abilityName = abilityName, players = players })
end

function API.StartAbility(owner: jecs.Entity, abilityName: string)
	local ability = AbilityContainerOperations.GetAbilityFromContainer(owner, abilityName)
	assert(ability, `{abilityName} ability doesnt exist on {owner} entity!`)
	AbilityStateOperations.StartAbility(ability)
end

function API.InterruptAbility(owner: jecs.Entity, abilityName: string)
	local ability = AbilityContainerOperations.GetAbilityFromContainer(owner, abilityName)
	assert(ability, `{abilityName} ability doesnt exist on {owner} entity!`)
	AbilityStateOperations.CancelAbility(ability)
end

function API._setupContainer(owner: jecs.Entity)
	WorldPoint:set(owner, Components.Shared.AbilityContainer, {} :: { [string]: any })
end
-- ^ testing

return API
