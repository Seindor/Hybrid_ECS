local Token = require("@Shared/Core/DependencyInjection/Commands/Token")
local Types = require("@Shared/Core/DependencyInjection/Data/Types")

local TypedModule = require("@Shared/Core/RuntimeScheduler/Data/Types/")

return {
	token = Token.create("RuntimeScheduler") :: Types.Token<TypedModule.Module>,
}
