export type IDatabaseAdapter<T> = {
	Load: (self: any, id: string) -> { success: boolean, data: T?, reason: string? },
	Save: (self: any, id: string, data: T) -> (),
	Unload: (self: any, id: string) -> (),
	Get: (self: any, id: string) -> T?,
}

export type IStore<T> = {
	Get: () -> { [string]: T },
	Set: ({ [string]: T }) -> (),
}

export type IStoreAdapter<T> = {
	SaveToStore: (self: any, id: string, data: T) -> (),
	GetFromStore: (self: any, id: string) -> T,
	RemoveFromStore: (self: any, id: string) -> (),
}

return {}
