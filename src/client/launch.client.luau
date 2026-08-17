local ReplicatedStorage = game:GetService("ReplicatedStorage")

local bootstrapper = require("@Shared/Core/Bootstrapper/Serivces/BootstrapperService")

bootstrapper.Launch({
	ReplicatedStorage.Core,
	script.Parent,
}, "Bootstrap", "ClientBootstrap")
