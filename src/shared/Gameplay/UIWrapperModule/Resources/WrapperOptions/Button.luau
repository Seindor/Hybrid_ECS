--!strict
-- Options для UIWrapper, когда instance - GuiButton

local Events = require("../../Data/Events")
local Components = require("../../Data/Components")
local EffectsRegistry = require("../EffectsRegistry")

return {
	name = "UIButtonWrapper",
	effects = EffectsRegistry.Button,
	events = Events.Button,
} :: Components.Options
