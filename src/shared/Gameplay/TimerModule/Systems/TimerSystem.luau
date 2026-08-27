local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")

local system = {}

function system.UpdateTimers(dt: number?)
	dt = dt or 1 / 60

	for entity, timers in WorldPoint:query(Components.TimerContainer) do
		for _, timer in timers do
			timer.timeLeft -= dt
			if timer.timeLeft < 0 then timer.done = true end
		end
	end
end

return system
