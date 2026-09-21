local MatchRoundsInfo = require("./MatchRoundsInfo")

type MatchInfo = {
	Name: string,
	MaxPlayers: number,
	Round: number,

	MaxCharacterPickTime: number,
	Rounds: { [number]: MatchRoundsInfo.RoundInfo },

	AllowedRarities: { string }?,
}

local Matches = {}

Matches["Default"] = {

	Name = "Default",

	Round = 1,

	Rounds = {
		[1] = MatchRoundsInfo.Default,
		[2] = MatchRoundsInfo.Default,
		[3] = MatchRoundsInfo.Default,
	},
}

return Matches :: { [string]: MatchInfo }
