local Types = require("../Data/Types")
local TimerOperations = require("../Operations/TimerOperations")

local API = {}

function API.StartTimer(timer: Types.Timer, duration: number)
	TimerOperations.StartTimer(timer, duration)
end

function API.ResetTimer(timer: Types.Timer)
	TimerOperations.ResetTimer(timer)
end

function API.WaitForTimer(timer: Types.Timer)
	TimerOperations.WaitForTimer(timer)
end

return API
