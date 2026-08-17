--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Container = require("@SharedPackages/Core/DependencyInjection_Package/Sevices/Container")
local RegisterDependencies = require("@SharedPackages/Core/DependencyInjection_Package/Sevices/RegisterDependencies")

local CompositionRootShared = Container.new()

local sharedProvidersFolder = ReplicatedStorage:WaitForChild("DI"):WaitForChild("SharedProviders")

RegisterDependencies.register(CompositionRootShared, sharedProvidersFolder)

return CompositionRootShared
