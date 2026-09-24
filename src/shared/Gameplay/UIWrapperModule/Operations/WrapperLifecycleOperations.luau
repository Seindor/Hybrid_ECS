--!strict
--[[
	Жизненный цикл готовой обёртки (общий для Button и Frame): подписка на Destroying,
	IsDestroyed, Destroy.
]]

local Components = require("../Data/Components")
local WrapperCallbacksOperations = require("./WrapperCallbacksOperations")

local operations = {}

-- Когда уничтожается сам инстанс, уничтожаем и обёртку
function operations.BindDestroying(wrapper: Components.WrapperState)
	wrapper._janitor:Add(
		wrapper.instance.Destroying:Connect(function()
			WrapperCallbacksOperations.Fire(wrapper, "Destroying")
			operations.Destroy(wrapper)
		end),
		"Disconnect",
		"Event:Destroying"
	)
end

function operations.IsDestroyed(wrapper: Components.WrapperState): boolean
	return wrapper._destroyed
end

function operations.Destroy(wrapper: Components.WrapperState)
	if wrapper._destroyed then return end
	wrapper._destroyed = true

	table.clear(wrapper._callbacks)
	table.clear(wrapper._connected)
	table.clear(wrapper._toggles)

	for _, signal in wrapper._signals do
		signal:Destroy()
	end
	table.clear(wrapper._signals)

	wrapper._janitor:Destroy() -- рвёт все реальные RBXScriptSignal-коннекты разом

	local onDestroy = wrapper._onDestroy
	wrapper._onDestroy = nil
	if onDestroy then onDestroy(wrapper) end
end

return operations
