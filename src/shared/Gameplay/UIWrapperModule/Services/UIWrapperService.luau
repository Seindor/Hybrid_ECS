--!strict
--[[
	Реестр агрегатов. Зависит от Aggregates (и Types).

	Фиксы относительно старой версии:
	  * агрегат убирается из реестра, когда уничтожается (в т.ч. вместе с инстансом) -
	    раньше Map вечно держал ссылки на удалённые элементы;
	  * FixCanvas для оси X использует AbsoluteSize.X (раньше Y).
]]

local UIButtonAggregate = require(script.Parent.Parent.Aggregates.UIButtonAggregate)
local UIFrameAggregate = require(script.Parent.Parent.Aggregates.UIFrameAggregate)
local TypedAggregates = require(script.Parent.Parent.Types.TypedAggregates)

export type UIWrapperService = {
	Create: TypedAggregates.CreateWrapperFn,
	Get: TypedAggregates.GetWrapperFn,
	Remove: (self: UIWrapperService, instance: GuiObject, destroyInstance: boolean?) -> (),
	GetAll: (self: UIWrapperService) -> { TypedAggregates.AnyAggregate },
	Clear: (self: UIWrapperService) -> (),
	FixCanvas: (self: UIWrapperService, scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?) -> (),
}

local UIWrapperService = {}
UIWrapperService.__index = UIWrapperService

type Impl = typeof(setmetatable({} :: { _wrappers: { [GuiObject]: any } }, UIWrapperService))

function UIWrapperService.new(): UIWrapperService
	return setmetatable({ _wrappers = {} }, UIWrapperService) :: any
end

-- Типизация перегрузками задана в интерфейсе UIWrapperService (TypedAggregates.CreateWrapperFn)
function UIWrapperService.Create(self: Impl, instance: GuiObject): any
	local existing = self._wrappers[instance]
	if existing then
		return existing
	end

	local function onDestroy()
		self._wrappers[instance] = nil
	end

	local wrapper: any
	if instance:IsA("GuiButton") then
		wrapper = UIButtonAggregate.new(instance, onDestroy)
	else
		wrapper = UIFrameAggregate.new(instance, onDestroy)
	end

	self._wrappers[instance] = wrapper
	return wrapper
end

function UIWrapperService.Get(self: Impl, instance: GuiObject): any
	return self._wrappers[instance]
end

function UIWrapperService.Remove(self: Impl, instance: GuiObject, destroyInstance: boolean?)
	local wrapper = self._wrappers[instance]
	if not wrapper then
		return
	end

	wrapper:Destroy() -- через onDestroy сам уберётся из реестра

	if destroyInstance then
		instance:Destroy()
	end
end

function UIWrapperService.GetAll(self: Impl): { any }
	local result = {}
	for _, wrapper in self._wrappers do
		table.insert(result, wrapper)
	end
	return result
end

function UIWrapperService.Clear(self: Impl)
	for _, wrapper in table.clone(self._wrappers) do
		wrapper:Destroy()
	end
	table.clear(self._wrappers)
end

--[[
	Подгоняет CanvasSize ScrollingFrame под содержимое UIListLayout.
	В конец добавляется один лишний Padding.Scale (как и в оригинале).
]]
function UIWrapperService.FixCanvas(self: Impl, scrollingFrame: ScrollingFrame, axis: ("X" | "Y")?)
	local layout = scrollingFrame:FindFirstChildWhichIsA("UIListLayout")
	if not layout then
		return
	end

	local isVertical = axis ~= "X"
	local wrapper = self:Create(scrollingFrame)

	local function update()
		local content = layout.AbsoluteContentSize
		local size = scrollingFrame.AbsoluteSize
		local padding = layout.Padding.Scale

		if isVertical then
			scrollingFrame.CanvasSize = UDim2.fromOffset(0, content.Y + padding * size.Y)
		else
			scrollingFrame.CanvasSize = UDim2.fromOffset(content.X + padding * size.X, 0)
		end
	end

	update()

	wrapper._Janitor:Add(
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update),
		"Disconnect",
		"layout_AbsoluteContentSizeChanged"
	)

	wrapper._Janitor:Add(
		scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(update),
		"Disconnect",
		"layout_AbsoluteSizeChanged"
	)
end

return UIWrapperService
