--!strict
-- Options для UIWrapper, когда instance - GuiButton

local Events = require("../../Data/Events")
local Types = require("../../Data/Types")
local EffectsRegistry = require("../EffectsRegistry")

return {
	name = "UIButtonWrapper",
	effects = EffectsRegistry.Button,
	events = Events.Button,
} :: Types.Options
