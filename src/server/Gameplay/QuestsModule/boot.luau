local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local QuestReplicationSystem = require("./Systems/QuestReplicationSystem")
local QuestCreationSystem = require("./Systems/QuestCreationSystem")

return function(app: App.IApp)
	app:RegisterSystem(QuestCreationSystem.CreateQuest, RuntimePriorities.Request)
	app:RegisterSystem(QuestCreationSystem.DeleteQuest, RuntimePriorities.Request)

	app:RegisterSystem(QuestReplicationSystem.ReplicateAbility, RuntimePriorities.PostRequest)
end
