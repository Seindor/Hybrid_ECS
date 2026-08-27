local RunService = game:GetService("RunService")

local promise = require("@RbxPackages/promise")
local sift = require("@RbxPackages/sift")

local constructor = {}

local service = {}
service.__index = service

local function executeSystemGroup(systems: { (dt: number?) -> () }, dt: number)
	for _, system in pairs(systems) do
		promise.try(system, dt)
	end
end

local function scheduleSystems(app: IApp)
	local completed = true
	local dt = 1 / 60
	--add unbind later

	RunService:BindToSimulation(function()
		if not completed then return end
		completed = false

		for _, priorityGroup in pairs(app.UpdateOrder) do
			promise
				.try(executeSystemGroup, priorityGroup, dt)
				:catch(function(...)
					warn(`System Error: `, ...)
				end)
				:await()
		end

		completed = true
	end, Enum.StepFrequency.Hz60, 200)
end

type tempValue = { priority: number, systems: { (dt: number?) -> () } }

local function recalculateUpdateOrder(app: IApp)
	table.clear(app.UpdateOrder)

	local createdGroups: { [string]: tempValue } = {}
	local temp: { tempValue } = {}

	for _, system in ipairs(app.Systems) do
		local id = tostring(system.priority)
		local group = createdGroups[id]

		if not group then
			createdGroups[id] = {
				priority = system.priority,
				systems = {},
			}
			group = createdGroups[id]
			table.insert(temp, group)
		end

		table.insert(group.systems, system.system)
	end

	table.sort(temp, function(a0: tempValue, a1: tempValue)
		return a0.priority > a1.priority
	end)

	for a0, priorityGroup in temp do
		table.insert(app.UpdateOrder, priorityGroup.systems)
	end
end

export type IApp = typeof(service) & {
	Systems: {
		{
			priority: number,
			system: (dt: number?) -> (),
		}
	},

	UpdateOrder: { { (dt: number?) -> () } },
}

function constructor.new()
	local self = setmetatable({}, service)

	self.Systems = {}
	self.UpdateOrder = {}

	return self :: IApp
end

function service.RegisterBootFiles(self: IApp, container: Instance)
	for _, module in pairs(container:GetDescendants()) do
		if not module:IsA("ModuleScript") then continue end
		if module.Name ~= "boot" then continue end
		(require)(module)(self)
	end
end

function service.RegisterResource<T>(self: IApp, token: { Resource: T }, resource: T)
	token.Resource = resource
	return self
end

function service.RegisterSystem(self: IApp, system: (dt: number?) -> (), systemPriority: number)
	table.insert(self.Systems, {
		priority = systemPriority,
		system = system,
	})
end

function service.Init(self: IApp)
	recalculateUpdateOrder(self)
	scheduleSystems(self)
end

return constructor
