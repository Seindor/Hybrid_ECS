local RunService = game:GetService("RunService")

local promise = require("@RbxPackages/promise")

local constructor = {}

local service = {}
service.__index = service

local function executeSystemGroup(systems: { (dt: number?) -> () }, dt: number)
	for _, system in pairs(systems) do
		promise.try(system, dt)
	end
end

local function scheduleSystems(app: IApp)
	RunService:UnbindFromRenderStep("Systems")

	RunService:BindToRenderStep("Systems", 100, function(dt)
		for _, priorityGroup in pairs(app.UpdateOrder) do
			promise
				.try(executeSystemGroup, priorityGroup, dt)
				:catch(function(...)
					warn(`System Error: `, ...)
				end)
				:await()
		end
	end)
end

local function recalculateUpdateOrder(app: IApp)
	table.clear(app.UpdateOrder)

	local temp: { { (dt: number?) -> () } } = {}

	for _, system in ipairs(app.Systems) do
		local priority = temp[system.priority] or {}
		temp[system.priority] = priority

		table.insert(priority, system.system)
	end

	for _, priorityGroup in pairs(temp) do
		table.insert(app.UpdateOrder, priorityGroup)
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
