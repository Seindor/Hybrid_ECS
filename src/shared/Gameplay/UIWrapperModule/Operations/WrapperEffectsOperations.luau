--!strict
--[[
	Создание эффектов по имени (лениво, из реестра в Options) и их запуск.
]]

local Types = require("../Data/Types")
local Wrapper = require("../Data/Wrapper")

type Host = Wrapper.Wrapper

export type EffectEntry = { name: string, params: unknown? }

local operations = {}

function operations.GetEffect(self: Host, name: string): Types.IEffect
	local effect = self.effects[name]

	if not effect then
		local EffectClass = self._options.effects[name]
		if not EffectClass then error(`Эффект "{name}" недоступен для {self._options.name}`, 3) end

		effect = EffectClass.new(self)
		self.effects[name] = effect
	end

	return effect
end

-- "Повесить" пассивные эффекты (ScaleOnEnter и т.п.); одноразовые просто создаются
function operations.ApplyEffect(self: Host, names: { string })
	if self._destroyed then return end

	for _, name in names do
		local effect = operations.GetEffect(self, name)
		local apply = effect.Apply
		if apply then apply(effect) end
	end
end

-- entries: { { name = "SpringEffect", params = { duration = 0.5 } } }
function operations.EmitEffect(self: Host, entries: { EffectEntry })
	if self._destroyed then return end

	for _, entry in entries do
		local effect = operations.GetEffect(self, entry.name)
		effect:Emit(entry.params)
	end
end

return operations
