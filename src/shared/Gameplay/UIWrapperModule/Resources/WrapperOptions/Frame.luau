--!strict
-- Options для UIWrapper, когда instance - произвольный GuiObject (Frame, ScrollingFrame и т.д.)

local Events = require("../../Data/Events")
local Components = require("../../Data/Components")
local EffectsRegistry = require("../EffectsRegistry")

return {
	name = "UIFrameWrapper",
	effects = EffectsRegistry.Frame,
	events = Events.Frame,
} :: Components.Options
