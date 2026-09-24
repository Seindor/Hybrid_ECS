--!strict
--[[
	Данные реестра: один инстанс - один объект-обёртка (кнопки и фреймы раздельно).
	Модульный синглтон (как WorldPoint в ECS-пакетах): реестр один на клиента.
]]

local Components = require("./Components")

export type Registry = {
	buttons: { [GuiButton]: Components.AnyButtonWrapper },
	frames: { [GuiObject]: Components.AnyFrameWrapper },
}

local registry: Registry = {
	buttons = {},
	frames = {},
}

return registry
