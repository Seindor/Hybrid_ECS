--!strict

local janitor = require("@RbxPackages/janitor")

export type Callback = () -> ()

export type Group = {
	Registries: {
		[number]: { Callback },
	},

	Priorities: { number },
}

export type ModuleMethods = {
	Registry: (self: Module, groupPriority: number, systemPriority: number, callback: Callback) -> (),
	Tick: (self: Module) -> (),
	Launch: (self: Module) -> (),
}

export type Data = {
	Groups: {
		[number]: Group,
	},

	GroupPriorities: { number },

	_janitor: janitor.Janitor,
}

export type Module = Data & ModuleMethods

return {}
