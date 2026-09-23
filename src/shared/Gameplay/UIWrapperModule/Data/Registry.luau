--!strict
--[[
	Данные реестра обёрток: один GuiObject - одна обёртка.
	Живёт внутри экземпляра UIWrapperAPI, а не глобально.
]]

local Wrapper = require("./Wrapper")

export type Registry = {
	wrappers: { [GuiObject]: Wrapper.Wrapper },
}

local Registry = {}

function Registry.New(): Registry
	return { wrappers = {} }
end

return Registry
