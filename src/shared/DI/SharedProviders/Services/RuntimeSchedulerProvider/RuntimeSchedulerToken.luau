local Token = require("@Shared/Modules/Libraries/DependencyInjection/Commands/Token")
local Types = require("@Shared/Modules/Libraries/DependencyInjection/Types")

local TypedModule = require("@Shared/Modules/Libraries/RuntimeScheduler/Data/Types/")

return {
	token = Token.create("RuntimeScheduler") :: Types.Token<TypedModule.Module>,
}
