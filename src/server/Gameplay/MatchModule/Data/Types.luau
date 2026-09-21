local jecs = require("@RbxPackages/jecs")

export type CreateMatchRequestData = { matchName: string }
export type DeleteMatchRequestData = { match: jecs.Entity }

export type CreateRoundRequestData = { roundName: string }
export type DeleteRoundRequestData = { round: number }

export type AddPlayerToMatchRequestData = { match: jecs.Entity, player: jecs.Entity }
export type RemovePlayerFromMatchRequestData = { match: jecs.Entity, player: jecs.Entity }

export type ReplicateMatchRequestData = { match: jecs.Entity, players: { [Player]: boolean }? }

export type StartMatchRequestData = { match: jecs.Entity }
export type EndMatchRequestData = { match: jecs.Entity }

export type MatchCreatedEventData = { match: jecs.Entity }
export type MatchRemovedEventData = { match: jecs.Entity }

export type PlayerAddedEventData = { match: jecs.Entity, player: jecs.Entity }
export type PlayerRemovedEventData = { match: jecs.Entity, player: jecs.Entity }

return {}
