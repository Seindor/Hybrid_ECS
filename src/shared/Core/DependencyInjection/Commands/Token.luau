--!strict

local Types = require("../Types")

type Token<T> = Types.Token<T>

local Token = {}

function Token.create<T>(name: string): Token<T>
	return {
		__brand = "DI_TOKEN",
		_name = name,
	} :: Token<T>
end

return Token
