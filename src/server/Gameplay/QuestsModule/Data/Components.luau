local janitor = require("@RbxPackages/janitor")
local jecs = require("@RbxPackages/jecs")
local Types = require("./Types")
local Components = require("@SharedGameplay/QuestsModule/Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

return {
	Shared = Components,

	_QuestInternal = WorldPoint:component() :: jecs.Component<{
		_janitor: janitor.Janitor,
	}>,

	CreateQuestRequest = WorldPoint:component() :: jecs.Component<Types.CreateQuestRequestData>,
	DeleteQuestRequest = WorldPoint:component() :: jecs.Component<Types.DeleteQuestRequestData>,

	ReplicateQuestRequest = WorldPoint:component() :: jecs.Component<Types.ReplicateQuestRequestData>,
}
