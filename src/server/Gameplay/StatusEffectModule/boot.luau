local App = require("@SharedCore/App/Services/App")
local RuntimePriorities = require("@SharedInternal/ECS/RuntimePriorities")
local StatusEffectApply = require("./Systems/StatusEffectApply")
local StatusEffectRemove = require("./Systems/StatusEffectRemove")
local StatusEffectReplicate = require("./Systems/StatusEffectReplicate")
local StatusEffectSubscriber = require("./Systems/StatusEffectSubscriber")

return function(app: App.IApp)
	app:RegisterSystem(StatusEffectApply.ApplyStatusEffect, RuntimePriorities.Request)
	app:RegisterSystem(StatusEffectRemove.RemoveStatusEffect, RuntimePriorities.Request)
	app:RegisterSystem(StatusEffectReplicate.ReplicateStatusEffect, RuntimePriorities.PostRequest)
	app:RegisterSystem(StatusEffectSubscriber.OnTick, RuntimePriorities.PreEvent)
end