local Types = require("../Data/Types")
local operations = {}

function operations.StartTimer(timer: Types.Timer, duration: number)
	timer.duration = duration
	timer.timeLeft = duration
	timer.done = false
end

function operations.ResetTimer(timer: Types.Timer)
	timer.timeLeft = timer.duration
	timer.done = false
end

function operations.WaitForTimer(timer: Types.Timer)
	while not timer.done do
		task.wait()
	end
	-- ^ change to coroutines
end

return operations
