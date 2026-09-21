export type RoundInfo = {
	Name: string,
	MaxAimTime: number,
	MaxCharacters: number,
}

local Rounds = {}

Rounds["Default"] = {
	Name = "Default",

	MaxAimTime = 5,
	MaxCharacters = 1,
} :: RoundInfo

return Rounds :: { [string]: RoundInfo }
