--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Container = require("@Shared/Core/DependencyInjection/Sevices/Container")
local RegisterDependencies = require("@Shared/Core/DependencyInjection/Sevices/RegisterDependencies")

local CompositionRootShared = Container.new()

local sharedProvidersFolder = ReplicatedStorage:WaitForChild("DI"):WaitForChild("SharedProviders")

RegisterDependencies.register(CompositionRootShared, sharedProvidersFolder)

return CompositionRootShared
