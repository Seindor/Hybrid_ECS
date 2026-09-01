local jecs = require("@RbxPackages/jecs")
local AbilityInfo = require("@SharedContent/Info/AbilityInfo")
local Components = require("../../Data/Components")
local StateMachine = require("@SharedGameplay/AbilityModule/Data/AbilityStateMachine")
local Types = require("@SharedGameplay/AbilityModule/Data/Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local ability: Types.Ability = {
	Name = "Test",
	Phases = {},
}

ability.Phases[StateMachine.Phases.Charging] = function()
	print("Charging")
end
ability.Phases[StateMachine.Phases.Starting] = function(entity: jecs.Entity)
	local info = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	assert(info)

	print("Starting")
	print(`Changed CD: {info.CD}, Original CD: {AbilityInfo["Test"].CD}`)
	print(`Changed Damage: {info.Damage}, Original Damage: {AbilityInfo["Test"].Damage}`)
end
ability.Phases[StateMachine.Phases.Active] = function(entity: jecs.Entity)
	print("Active")
end
ability.Phases[StateMachine.Phases.Stoping] = function()
	print("Stoping")
end
ability.Phases[StateMachine.Phases.Recharging] = function()
	print("Recharging")
end
ability.Phases[StateMachine.Phases.Idle] = function()
	print("Idle")
end
ability.Phases[StateMachine.Phases.Interrupted] = function()
	print("Interrupted")
end

return ability
