local ReplicatedStorage = game:GetService("ReplicatedStorage")

local bootstrapper = require("@Shared/Modules/Libraries/Bootstrapper/Serivces/BootstrapperService")

bootstrapper.Launch({
	ReplicatedStorage.Modules,
}, "Bootstrap")
