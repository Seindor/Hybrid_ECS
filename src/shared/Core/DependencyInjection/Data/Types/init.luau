--!strict

export type Token<T = unknown> = {
	__brand: "DI_TOKEN",
	_name: string,
	_type: T?,
}

export type Lifetime = "Singleton" | "Scoped" | "Transient"

export type Inject = { [string]: Token<any> }

export type InjectableClass<T = unknown> = {
	new: () -> T,
}

export type Registry<T = unknown> = {
	token: Token<T>,
	register: (container: any) -> (),
}

return {}
