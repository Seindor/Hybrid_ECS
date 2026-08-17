local Container = require("@Shared/Modules/Libraries/DependencyInjection/Sevices/Container")

local registry = require("@Shared/DI/Generated/SharedRegistry")

local object = require("@Shared/Modules/Libraries/RuntimeScheduler/Services/RuntimeScheduler")

local Registry = {}
Registry.token = registry.Singletons.Services.RuntimeScheduler

function Registry.register(container: Container.ContainerObject)
	-- inject не передан явно -> Container сам возьмёт AbilityAPI._Inject
	container:BindSingletonClass(Registry.token, object)
end

return Registry
