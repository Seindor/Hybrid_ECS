local App = require("@SharedCore/App/Services/App")
local ProfileSystem = require("./Systems/ProfileConversionSystem")

return function(app: App.IApp)
	task.spawn(function()
		while task.wait(10) do
			ProfileSystem.ConvertProfile()
		end
	end)
end
