--!strict
--[[
	Публичный API. Как AbilityAPI: обычные функции с явными сигнатурами, работают через Systems
	и Operations. Возвращает объекты-обёртки с методами через ":".

	local btn = API.CreateButton(screenGui.PlayButton)   -- ButtonWrapper<TextButton>
	btn.instance.Text = "Play"                           -- instance сохраняет свой тип
	btn:AddCallback("Activated", "play", function() end)
	btn:ApplyEffect({ "ScaleOnEnter" })
	btn:EmitEffect({ { name = "SpringEffect", params = { duration = 0.5 } } })

	local win = API.CreateFrame(screenGui.Window)        -- FrameWrapper<Frame>
	win:AddCallback("Shown", "shown", function() end)
	win:EmitEffect({ { name = "MoveFrame", params = { duration = 1 } } })

	btn:Destroy()
]]

local Components = require("../Data/Components")
local WrapperRegistryOperations = require("../Operations/WrapperRegistryOperations")
local ButtonCreationSystem = require("../Systems/ButtonCreationSystem")
local FrameCreationSystem = require("../Systems/FrameCreationSystem")
local WrapperCanvasSystem = require("../Systems/WrapperCanvasSystem")
local WrapperLifecycleSystem = require("../Systems/WrapperLifecycleSystem")

local API = {}

--------------------------------------------------------------------------------
-- Кнопки
--------------------------------------------------------------------------------

-- Один инстанс - одна обёртка: повторный вызов вернёт ту же.
function API.CreateButton<I>(instance: I): Components.ButtonWrapper<I>
	return ButtonCreationSystem.Create(instance)
end

function API.GetButton<I>(instance: I): Components.ButtonWrapper<I>?
	return ButtonCreationSystem.Get(instance)
end

function API.RemoveButton(instance: GuiButton, destroyInstance: boolean?)
	ButtonCreationSystem.Remove(instance, destroyInstance)
end

--------------------------------------------------------------------------------
-- Фреймы (любой GuiObject: Frame, ScrollingFrame, TextLabel, ...)
--------------------------------------------------------------------------------

function API.CreateFrame<I>(instance: I): Components.FrameWrapper<I>
	return FrameCreationSystem.Create(instance)
end

function API.GetFrame<I>(instance: I): Components.FrameWrapper<I>?
	return FrameCreationSystem.Get(instance)
end

function API.RemoveFrame(instance: GuiObject, destroyInstance: boolean?)
	FrameCreationSystem.Remove(instance, destroyInstance)
end

--------------------------------------------------------------------------------
-- Без указания типа: кнопка/фрейм выбирается по классу инстанса (GuiButton -> кнопка)
--------------------------------------------------------------------------------

function API.Create(instance: GuiObject): Components.AnyWrapper
	if instance:IsA("GuiButton") then return ButtonCreationSystem.Create(instance) end
	return FrameCreationSystem.Create(instance)
end

function API.Get(instance: GuiObject): Components.AnyWrapper?
	if instance:IsA("GuiButton") then return ButtonCreationSystem.Get(instance) end
	return FrameCreationSystem.Get(instance)
end

function API.Remove(instance: GuiObject, destroyInstance: boolean?)
	if instance:IsA("GuiButton") then
		ButtonCreationSystem.Remove(instance, destroyInstance)
	else
		FrameCreationSystem.Remove(instance, destroyInstance)
	end
end

function API.GetAllButtons(): { Components.AnyButtonWrapper }
	return WrapperRegistryOperations.GetAllButtons()
end

function API.GetAllFrames(): { Components.AnyFrameWrapper }
	return WrapperRegistryOperations.GetAllFrames()
end

-- Уничтожает все обёртки
function API.Clear()
	WrapperLifecycleSystem.Clear()
end

-- Подгоняет CanvasSize под содержимое UIListLayout (пересчитывается при изменениях)
function API.FixCanvas(scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?)
	WrapperCanvasSystem.FixCanvas(scrollingFrame, axis)
end

return API
