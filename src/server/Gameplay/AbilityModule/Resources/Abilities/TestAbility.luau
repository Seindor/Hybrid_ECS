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

ability.Phases[StateMachine.Phases.Charging] = function(entity: jecs.Entity)
	local info = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	assert(info)

	info.CD = 10
	info.Damage += 10

	print("Charging")
	WorldPoint:set(entity, Components.Shared.AbilityInfo, info)
	task.wait(1)
end
ability.Phases[StateMachine.Phases.Starting] = function(entity)
	local info = WorldPoint:get(entity, Components.Shared.AbilityInfo)
	assert(info)

	print("Starting")
	print(`Changed CD: {info.CD}, Original CD: {AbilityInfo["Test"].CD}`)

	task.wait(1)
end
ability.Phases[StateMachine.Phases.Active] = function()
	print("Active")
	task.wait(1)
end
ability.Phases[StateMachine.Phases.Stoping] = function()
	print("Stoping")
	task.wait(1)
end
ability.Phases[StateMachine.Phases.Recharging] = function()
	print("Recharging")
end
ability.Phases[StateMachine.Phases.Idle] = function()
	print("Idle")
	task.wait(1)
end
ability.Phases[StateMachine.Phases.Interrupted] = function()
	print("Interrupted")
	task.wait(1)
end

return ability
