--!strict
--[[
	Эффекты кнопки. Имена и params ограничены UIButtonEffectName / UIButtonEffectEntry.
]]

local Components = require("../Data/Components")
local Types = require("../Data/Types")
local WrapperEffectsOperations = require("../Operations/WrapperEffectsOperations")

local system = {}

function system.ApplyEffect(wrapper: Components.WrapperState, names: { Types.UIButtonEffectName })
	for _, name in names do
		WrapperEffectsOperations.Apply(wrapper, name)
	end
end

function system.EmitEffect(wrapper: Components.WrapperState, entries: { Types.UIButtonEffectEntry })
	for _, entry in entries do
		WrapperEffectsOperations.Emit(wrapper, entry.name, entry.params)
	end
end

return system
