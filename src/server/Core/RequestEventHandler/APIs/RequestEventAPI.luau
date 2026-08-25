local RequestEventsOperations = require("../Operations/RequestEventsOperations")

local API = {}

function API.CreateRequest()
	return RequestEventsOperations.CreateRequest()
end

function API.CreateEvent()
	return RequestEventsOperations.CreateEvent()
end

return API
