local jecs = require("@RbxPackages/jecs")
local Types = require("@SharedGameplay/QuestsModule/Data/Types")

export type CreateQuestRequestData = { name: string, owner: jecs.Entity, progress: Types.ProgressEntryData? }
export type DeleteQuestRequestData = { name: string, owner: jecs.Entity }

export type ReplicateQuestRequestData = {
	owner: jecs.Entity,
	questName: string,
	players: { [Player]: boolean }?,
}

return {}
