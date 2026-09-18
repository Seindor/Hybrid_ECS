local Types = require("@SharedGameplay/PassiveModule/Data/Types")
local Components = require("../../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local passive = {} :: Types.IPassiveObject

function passive.OnAttach(_owner, passiveEntity)
	local info = WorldPoint:get(passiveEntity, Components.PassiveInfo)
	print("Attached Passive", info and info.name or passiveEntity)
end

function passive.OnTick(_owner, passiveEntity)
	print(WorldPoint:has(passiveEntity, Components.PassiveActive))
end

return passive