local Interfaces = require("@SharedGameplay/StatusEffectModule/Data/Interfaces")
local AttributeConstructionAPI = require("@SharedGameplay/AttributeModule/APIs/AttributeConstructionAPI")
local Components = require("../../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local aura = {} :: Interfaces.IStatusEffectObject

function aura.OnApply(owner, effect)
	local modifierId = AttributeConstructionAPI.CreateModifier(owner, {
		tags = { "Add" },
		value = 5,
	})

	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if info then
		info.data.modifierId = modifierId
		WorldPoint:set(effect, Components.Shared.StatusEffectInfo, info)
	end
end

function aura.OnRemove(owner, effect)
	local info = WorldPoint:get(effect, Components.Shared.StatusEffectInfo)
	if not info then return end

	local modifierId = info.data.modifierId
	if modifierId then AttributeConstructionAPI.RemoveModifier(owner, modifierId) end
end

return aura