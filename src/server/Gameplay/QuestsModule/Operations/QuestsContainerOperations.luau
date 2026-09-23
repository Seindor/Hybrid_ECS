local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local operations = {}

function operations.AddQuestToContainer(owner: jecs.Entity, quest: jecs.Entity)
	local container = WorldPoint:get(owner, Components.Shared.QuestsContainer)
	if not container then return end

	local questInfo = WorldPoint:get(quest, Components.Shared.QuestInfo)

	if not questInfo then return end

	container[questInfo.Name] = quest
	WorldPoint:set(owner, Components.Shared.QuestsContainer, container)
end

function operations.PopQuest(owner: jecs.Entity, questName: string): jecs.Entity?
	local container: { [string]: any } = WorldPoint:get(owner, Components.Shared.QuestsContainer)
	if not container then return nil end

	local quest = container[questName]
	container[questName] = nil

	WorldPoint:set(owner, Components.Shared.QuestsContainer, container)
	return quest
end

function operations.GetAbilityFromContainer(owner: jecs.Entity, questName: string): jecs.Entity?
	local container = WorldPoint:get(owner, Components.Shared.QuestsContainer)
	if not container then return nil end

	return container[questName]
end

return operations
