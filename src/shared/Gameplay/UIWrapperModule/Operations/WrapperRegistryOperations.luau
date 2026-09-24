--!strict
--[[
	Операции над реестром. Аналог AbilityContainerOperations.

	Реестр хранит объекты как <GuiButton> / <GuiObject>, а наружу нужен точный <I>. Запись по
	ключу-инстансу всегда создана для того же I, поэтому Add*/Get* - единственное место со
	стиранием типа (:: any).
]]

local Components = require("../Data/Components")
local Registry = require("../Data/Registry")

local operations = {}

function operations.AddButton<I>(instance: I & GuiButton, wrapper: Components.ButtonWrapper<I>)
	Registry.buttons[instance] = wrapper :: any
end

function operations.GetButton<I>(instance: I & GuiButton): Components.ButtonWrapper<I>?
	return Registry.buttons[instance] :: any
end

function operations.PopButton(instance: GuiButton)
	Registry.buttons[instance] = nil
end

function operations.AddFrame<I>(instance: I & GuiObject, wrapper: Components.FrameWrapper<I>)
	Registry.frames[instance] = wrapper :: any
end

function operations.GetFrame<I>(instance: I & GuiObject): Components.FrameWrapper<I>?
	return Registry.frames[instance] :: any
end

function operations.PopFrame(instance: GuiObject)
	Registry.frames[instance] = nil
end

function operations.GetAllButtons(): { Components.AnyButtonWrapper }
	local result: { Components.AnyButtonWrapper } = {}
	for _, wrapper in Registry.buttons do
		table.insert(result, wrapper)
	end
	return result
end

function operations.GetAllFrames(): { Components.AnyFrameWrapper }
	local result: { Components.AnyFrameWrapper } = {}
	for _, wrapper in Registry.frames do
		table.insert(result, wrapper)
	end
	return result
end

function operations.Clear()
	table.clear(Registry.buttons)
	table.clear(Registry.frames)
end

return operations
