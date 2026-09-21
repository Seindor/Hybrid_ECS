local jecs = require("@RbxPackages/jecs")
local MatchStateMachine = require("./MatchStateMachine")

export type Match = {
	Name: string,
	Phases: { [MatchStateMachine.Phases]: (jecs.Entity) -> () },
}

export type Round = {
	Name: string,
	Phases: { [MatchStateMachine.Phases]: (jecs.Entity) -> () },
}

export type RoundInfo = {
	Name: string,
	MaxAimTime: number,
	MaxCharacters: number,
}

export type MatchInfo = {
	Name: string,

	MaxPlayers: number,

	Round: number,

	MaxCharacterPickTime: number,
	Players: { jecs.Entity },
	Rounds: { [number]: RoundInfoData },

	AllowedRarities: { string }?,
}

export type RoundInfoData = {
	Name: string,

	owner: jecs.Entity,

	phase: jecs.Entity,

	winner: jecs.Entity?,
	loser: jecs.Entity?,
}

return {}
