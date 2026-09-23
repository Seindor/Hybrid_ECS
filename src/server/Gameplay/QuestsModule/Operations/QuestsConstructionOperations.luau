local janitor = require("@RbxPackages/janitor")
local jecs = require("@RbxPackages/jecs")
local sift = require("@RbxPackages/sift")
local Components = require("../Data/Components")
local QuestsInfo = require("@SharedContent/Info/QuestsInfo")
local Types = require("../Data/Types")
local SharedTypes = require("@SharedGameplay/QuestsModule/Data/Types")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")

local operations = {}

function operations.CreateQuest(data: Types.CreateQuestRequestData): jecs.Entity?
	local questInfo = QuestsInfo[data.name]

	if not questInfo then return nil end

	local entity = WorldPoint:entity()

	WorldPoint:set(entity, Components.Shared.QuestInfo, sift.Dictionary.copyDeep(questInfo))
	WorldPoint:set(entity, Components.Shared.Progress, {} :: SharedTypes.ProgressEntryData)

	WorldPoint:set(entity, Components.Shared.Owner, data.owner)

	WorldPoint:set(entity, Components._QuestInternal, {
		_janitor = janitor.new(),
	})

	return entity
end

function operations.DeleteQuest(quest: jecs.Entity)
	WorldPoint:delete(quest)
end

return operations
