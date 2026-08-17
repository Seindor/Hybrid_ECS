return {
	SCHEMAS_FILE = {
		--"./src/ReplicatedStorage/Signals/ClientBindableSchemas.luau",
		--"./src/ReplicatedStorage/Signals/ServerBindableSchemas.luau",
		--"./src/ReplicatedStorage/Signals/RemoteSchemas.luau",
		"./src/shared/Signals/serverSchemas.luau",
		"./src/shared/Signals/clientSchemas.luau",
		"./src/shared/Signals/sharedSchemas.luau",
	},
	OUT_SINGALS_CLIENT = "./src/shared/Signals/init.luau",
	OUT_SINGALS_SERVER = "./src/server/Signals/init.luau",
	INTERFACE_MODULES = {
		"./src/shared/Interfaces/Classes/Modules.luau",
		"./src/server/Interfaces/Classes/Modules.luau",
	},

	GLOBAL_CONFIG = {
		DEV_PLACE_ID = 95296908800473,
		DEV_GAME_ID = 95296908800473,

		MAIN_PLACE_ID = "",
		MAIN_GAME_ID = "",

		ORIGIN_NAME = "origin",
	},
}