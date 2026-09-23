--!strict
--[[
	Публичная точка входа. Зависит только от Services.

	local api = UIWrapperAPI.new()

	-- CreateButton / CreateFrame сами подхватывают тип инстанса из аргумента:
	local btn = api:CreateButton(screenGui.PlayButton)  -- IUIButtonAggregate<TextButton>
	btn.instance.Text                                    -- string, а не GuiButton
	local win = api:CreateFrame(screenGui.Window)        -- IUIFrameAggregate<Frame>

	-- то же, но тип указан явно (нужен Luau с синтаксисом <<...>>):
	local btn2 = api:CreateButton<<typeof(screenGui.PlayButton)>>(screenGui.PlayButton)

	-- Create: тип агрегата задаёшь сам - аннотацией или через <<...>>
	local a: TypedAggregates.IUIButtonAggregate<TextButton> = api:Create(screenGui.PlayButton)
	local b = api:Create<<TypedAggregates.IUIFrameAggregate<Frame>>>(screenGui.Window)
]]

local UIWrapperService = require("../Services/UIWrapperService")
local TypedAggregates = require("../Types/TypedAggregates")

export type UIWrapperAPI = {
	service: UIWrapperService.UIWrapperService,

	Create: <A>(self: UIWrapperAPI, instance: GuiObject) -> A,
	CreateButton: <I>(self: UIWrapperAPI, instance: I & GuiButton) -> TypedAggregates.IUIButtonAggregate<I>,
	CreateFrame: <I>(self: UIWrapperAPI, instance: I & GuiObject) -> TypedAggregates.IUIFrameAggregate<I>,

	Get: <A>(self: UIWrapperAPI, instance: GuiObject) -> A?,
	GetButton: <I>(self: UIWrapperAPI, instance: I & GuiButton) -> TypedAggregates.IUIButtonAggregate<I>?,
	GetFrame: <I>(self: UIWrapperAPI, instance: I & GuiObject) -> TypedAggregates.IUIFrameAggregate<I>?,

	Remove: (self: UIWrapperAPI, instance: GuiObject, destroyInstance: boolean?) -> (),
	GetAll: (self: UIWrapperAPI) -> { TypedAggregates.IUICommonAggregate },
	Clear: (self: UIWrapperAPI) -> (),
	FixCanvas: (self: UIWrapperAPI, scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?) -> (),
}

local UIWrapperAPI = {}
UIWrapperAPI.__index = UIWrapperAPI

type Impl = typeof(setmetatable({} :: { service: UIWrapperService.UIWrapperService }, UIWrapperAPI))

function UIWrapperAPI.new(): UIWrapperAPI
	return setmetatable({ service = UIWrapperService.new() }, UIWrapperAPI) :: any
end

function UIWrapperAPI.Create(self: Impl, instance: GuiObject): any
	return self.service:Create(instance)
end

function UIWrapperAPI.CreateButton(self: Impl, instance: GuiButton): any
	return self.service:CreateButton(instance)
end

function UIWrapperAPI.CreateFrame(self: Impl, instance: GuiObject): any
	return self.service:CreateFrame(instance)
end

function UIWrapperAPI.Get(self: Impl, instance: GuiObject): any
	return self.service:Get(instance)
end

function UIWrapperAPI.GetButton(self: Impl, instance: GuiButton): any
	return self.service:GetButton(instance)
end

function UIWrapperAPI.GetFrame(self: Impl, instance: GuiObject): any
	return self.service:GetFrame(instance)
end

function UIWrapperAPI.Remove(self: Impl, instance: GuiObject, destroyInstance: boolean?)
	self.service:Remove(instance, destroyInstance)
end

function UIWrapperAPI.GetAll(self: Impl): { any }
	return self.service:GetAll()
end

function UIWrapperAPI.Clear(self: Impl)
	self.service:Clear()
end

function UIWrapperAPI.FixCanvas(self: Impl, scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?)
	self.service:FixCanvas(scrollingFrame, axis)
end

return UIWrapperAPI
