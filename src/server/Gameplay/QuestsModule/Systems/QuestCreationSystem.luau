local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local QuestsEventsOperations = require("../Operations/QuestsEventsOperations")
local QuestsContainerOperations = require("../Operations/QuestsContainerOperations")
local QuestsConstructionOperations = require("../Operations/QuestsConstructionOperations")
local Components = require("../Data/Components")

local system = {}

function system.CreateQuest()
	for _, data in WorldPoint:query(Components.CreateQuestRequest) do
		local quest = QuestsConstructionOperations.CreateQuest(data)
		if not quest then return end
		QuestsContainerOperations.AddQuestToContainer(data.owner, quest)
		QuestsEventsOperations.EmitQuestCreation()
	end
end

function system.DeleteQuest()
	for _, data in WorldPoint:query(Components.DeleteQuestRequest) do
		local quest = QuestsContainerOperations.PopQuest(data.owner, data.name)
		if not quest then continue end
		QuestsConstructionOperations.DeleteQuest(quest)
		QuestsEventsOperations.EmitQuestDeletion()
	end
end

return system
