--!strict
--[[
	Запуск одного эффекта по имени из Options обёртки. Перебор списков - в Systems/*EffectsSystem.
]]

local Components = require("../Data/Components")

local operations = {}

local function getEffect(wrapper: Components.WrapperState, name: string): Components.Effect
	local effect = wrapper._options.effects[name]
	if not effect then error(`Эффект "{name}" недоступен для {wrapper._options.name}`, 3) end
	return effect
end

-- "Повесить" пассивный эффект (ScaleOnEnter и т.п.); у одноразовых Apply нет
function operations.Apply(wrapper: Components.WrapperState, name: string)
	if wrapper._destroyed then return end

	local apply = getEffect(wrapper, name).Apply
	if apply then apply(wrapper) end
end

function operations.Emit(wrapper: Components.WrapperState, name: string, params: unknown)
	if wrapper._destroyed then return end

	getEffect(wrapper, name).Emit(wrapper, params)
end

return operations
