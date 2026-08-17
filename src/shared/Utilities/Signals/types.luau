local Enums = {
	EventType = {
		Bindable = "Bindable",
		Remote = "Remote",
	},
}

local gt = require("@RbxPackages/greentea")

export type Event = {
	-- fields
	Name: string,
	Instance: RemoteEvent?,
	Connections: { [string]: { (...any) -> () } },
	WaitConnections: { [string]: { (...any) -> () } },
	OnceConnections: { [string]: { (...any) -> () } },
	Type: keyof<typeof(Enums.EventType)>,
	Validator: gt.Type?,

	-- methods
	Fire: (self: Event, scope: string, ...any) -> (),
	FireAll: (self: Event, scope: string, ...any) -> (),
	FireInRadius: (self: Event) -> (), -- placeholder, as in implementation
	Connect: (self: Event, scope: string, callback: (...any) -> any) -> (),
}

export type BindableScope<T> = {
	Name: string,
	Type: keyof<typeof(Enums.EventType)>,

	Fire: (self: ClientScope<T>, payload: T) -> (),
	Connections: { (payload: T) -> () },
	Connect: (self: BindableScope<T>, callback: (payload: T) -> ()) -> (),
}

export type ClientScope<T> = {
	Name: string,
	Type: keyof<typeof(Enums.EventType)>,

	Fire: (self: ClientScope<T>, payload: T) -> (),
	Connections: { (payload: T) -> () },
	Connect: (self: ClientScope<T>, callback: (payload: T) -> ()) -> (),
}

export type ServerScope<T> = {
	Name: string,
	Type: keyof<typeof(Enums.EventType)>,

	Fire: (self: ServerScope<T>, player: Player, payload: T) -> (),
	FireAll: (self: ServerScope<T>, payload: T) -> (),
	FireInRadius: (self: ServerScope<T>) -> (), -- tb implemented

	Connections: { (payload: T) -> () },
	Connect: (self: ServerScope<T>, callback: (player: Player, payload: T) -> ()) -> (),
}

return {}
