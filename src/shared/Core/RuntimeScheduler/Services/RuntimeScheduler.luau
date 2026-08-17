--!strict

local RunService = game:GetService("RunService")

local typedModule = require("../Data/Types")
local janitor = require("@RbxPackages/janitor")

local RuntimeScheduler = {}
RuntimeScheduler.__index = RuntimeScheduler

local function errorHandler(err: unknown)
	warn(`[RuntimeScheduler] System failed:\n{tostring(err)}`)
	return debug.traceback(tostring(err), 2)
end

local function executeSystem(callback: typedModule.Callback)
	xpcall(callback, errorHandler)
end

local function runGroup(group: typedModule.Group)
	for _, priority in group.Priorities do
		local callbacks = group.Registries[priority]

		for _, callback in callbacks do
			executeSystem(callback)
		end
	end
end

function RuntimeScheduler.new(): typedModule.Module
	local self = setmetatable({}, RuntimeScheduler) :: typedModule.Module

	self.Groups = {}
	self.GroupPriorities = {}
	self._janitor = janitor.new()

	return self
end

local function getOrCreateGroup(self: typedModule.Module, groupPriority: number): typedModule.Group
	local group = self.Groups[groupPriority]

	if not group then
		group = {
			Registries = {},
			Priorities = {},
		}

		self.Groups[groupPriority] = group

		table.insert(self.GroupPriorities, groupPriority)

		table.sort(self.GroupPriorities)
	end

	return group
end

function RuntimeScheduler.Registry(
	self: typedModule.Module,
	groupPriority: number,
	systemPriority: number,
	callback: typedModule.Callback
)
	local group = getOrCreateGroup(self, groupPriority)

	local bucket = group.Registries[systemPriority]

	if not bucket then
		bucket = {}

		group.Registries[systemPriority] = bucket

		table.insert(group.Priorities, systemPriority)

		table.sort(group.Priorities)
	end

	table.insert(bucket, callback)
end

function RuntimeScheduler.Tick(self: typedModule.Module)
	for _, groupPriority in self.GroupPriorities do
		local group = self.Groups[groupPriority]

		runGroup(group)
	end
end

function RuntimeScheduler.Launch(self: typedModule.Module)
	self._janitor:Add(
		RunService.Heartbeat:Connect(function()
			self:Tick()
		end),
		"Disconnect",
		"Update"
	)
end

return RuntimeScheduler
