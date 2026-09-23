local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")

return {
	Owner = WorldPoint:component() :: jecs.Component<jecs.Entity>,

	QuestsContainer = WorldPoint:component() :: jecs.Component<{ [string]: jecs.Entity }>,

	QuestInfo = WorldPoint:component() :: jecs.Component<Types.QuestInfoData>,
	Progress = WorldPoint:component() :: jecs.Component<Types.ProgressEntryData>,
}
