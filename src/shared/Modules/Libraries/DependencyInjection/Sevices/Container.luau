--!strict

local Types = require("../Data/Types")

type Token<T> = Types.Token<T>
type Lifetime = Types.Lifetime
type Inject = Types.Inject
type InjectableClass<T> = Types.InjectableClass<T>

type Factory<T> = (scope: any) -> T

type Binding = {
	Lifetime: Lifetime,
	Factory: Factory<any>,
}

--============================================================
-- Container
--============================================================

local Container = {}
Container.__index = Container

type ContainerFields = {
	_Bindings: { [Token<any>]: Binding },
	_Singletons: { [Token<any>]: any },
}

export type ContainerObject = typeof(setmetatable({} :: ContainerFields, Container))

--============================================================
-- Типы Scope объявлены здесь же, ДО их использования в Container.CreateScope.
-- ВАЖНО: без явной аннотации `local Scope: ScopeClass` Luau выводит тип
-- форвард-декларации как `nil | <таблица>`, потому что видит `local Scope`
-- раньше присваивания `Scope = {}` ниже по файлу — отсюда "Value ... could be nil".
-- Явный тип убирает nil из вывода целиком.
--============================================================

type ScopeFields = {
	_Container: ContainerObject,
	_Scoped: { [Token<any>]: any },
}

-- ScopeObject не выводится через typeof(setmetatable(..., Scope)) специально:
-- так он не зависит от типа самой таблицы Scope и не создаёт кольцевую зависимость типов.
export type ScopeObject = ScopeFields & {
	resolve: <T>(self: ScopeObject, token: Token<T>) -> T,
}

type ScopeClass = {
	__index: ScopeClass,
	new: (container: ContainerObject) -> ScopeObject,
	resolve: <T>(self: ScopeObject, token: Token<T>) -> T,
}

-- forward declaration с явным типом — Scope живёт в этом же файле, чтобы избежать
-- циклического require, но объявлен раньше Container.CreateScope, которому он нужен
local Scope: ScopeClass

function Container.new(): ContainerObject
	local self = setmetatable({} :: ContainerFields, Container)
	self._Bindings = {}
	self._Singletons = {}
	return self
end

local function bind<T>(self: ContainerObject, lifetime: Lifetime, token: Token<T>, factory: Factory<T>)
	self._Bindings[token] = { Lifetime = lifetime, Factory = factory }
end

--------------------------------------------------------------
-- Низкоуровневые байнды: полный контроль над фабрикой
--------------------------------------------------------------

function Container.BindSingleton<T>(self: ContainerObject, token: Token<T>, factory: Factory<T>)
	bind(self, "Singleton", token, factory)
end

function Container.BindScoped<T>(self: ContainerObject, token: Token<T>, factory: Factory<T>)
	bind(self, "Scoped", token, factory)
end

function Container.BindTransient<T>(self: ContainerObject, token: Token<T>, factory: Factory<T>)
	bind(self, "Transient", token, factory)
end

--------------------------------------------------------------
-- Сахар: создаёт Class.new() без аргументов, затем проставляет резолвленные
-- зависимости напрямую в поля инстанса по карте Inject (ключ = имя поля).
--------------------------------------------------------------

-- Если inject не передан явно — берётся Class._Inject: класс сам объявляет, что ему нужно.
-- Приведение к any намеренное — см. комментарий у InjectableClass в Types.luau.
local function classFactory<T>(Class: InjectableClass<T>, inject: Inject?): Factory<T>
	local resolvedInject = inject or (Class :: any)._Inject :: Inject?

	return function(scope)
		local instance = Class.new()

		if resolvedInject then
			for fieldName, dependencyToken in resolvedInject do
				(instance :: any)[fieldName] = scope:resolve(dependencyToken)
			end
		end

		return instance
	end
end

function Container.BindSingletonClass<T>(
	self: ContainerObject,
	token: Token<T>,
	Class: InjectableClass<T>,
	inject: Inject?
)
	bind(self, "Singleton", token, classFactory(Class, inject))
end

function Container.BindScopedClass<T>(self: ContainerObject, token: Token<T>, Class: InjectableClass<T>, inject: Inject?)
	bind(self, "Scoped", token, classFactory(Class, inject))
end

function Container.BindTransientClass<T>(
	self: ContainerObject,
	token: Token<T>,
	Class: InjectableClass<T>,
	inject: Inject?
)
	bind(self, "Transient", token, classFactory(Class, inject))
end

function Container._GetBinding(self: ContainerObject, token: Token<any>): Binding?
	return self._Bindings[token]
end

function Container._GetSingleton(self: ContainerObject, token: Token<any>): any
	return self._Singletons[token]
end

function Container._SetSingleton(self: ContainerObject, token: Token<any>, value: any)
	self._Singletons[token] = value
end

function Container.CreateScope(self: ContainerObject): ScopeObject
	return Scope.new(self)
end

--============================================================
-- Scope — реализация (типы уже объявлены выше, до Container.CreateScope)
--============================================================

Scope = {} :: ScopeClass
Scope.__index = Scope

function Scope.new(container: ContainerObject): ScopeObject
	local self = setmetatable({} :: ScopeFields, Scope) :: ScopeObject
	self._Container = container
	self._Scoped = {}
	return self
end

-- Singleton — кэш на контейнере (переживает scope), Scoped — кэш на этом scope,
-- Transient — новый инстанс при каждом resolve
function Scope.resolve<T>(self: ScopeObject, token: Token<T>): T
	local binding = self._Container:_GetBinding(token)
	if not binding then error(`DI: токен не забинден: {token._name}`) end

	if binding.Lifetime == "Singleton" then
		local cachedSingleton = self._Container:_GetSingleton(token)
		if cachedSingleton ~= nil then return cachedSingleton end
		local createdSingleton = binding.Factory(self)
		self._Container:_SetSingleton(token, createdSingleton)
		return createdSingleton
	end

	if binding.Lifetime == "Scoped" then
		local cachedScoped = self._Scoped[token]
		if cachedScoped ~= nil then return cachedScoped end
		local createdScoped = binding.Factory(self)
		self._Scoped[token] = createdScoped
		return createdScoped
	end

	return binding.Factory(self)
end

return Container
