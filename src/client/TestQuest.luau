local quest = {
	Data = {
		DisplayName = "",
		Description = "",
		Progress = {
			["Shards"] = { amount = 0 },
		},
		Requirements = {
			["Shards"] = { kind = "Currency", attribute = "Shards", amount = 100 },
		},
	},

	Check = function(...) end,
}

return quest
