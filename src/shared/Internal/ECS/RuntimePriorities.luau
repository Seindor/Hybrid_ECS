local Data = {
	Groups = {
		Physic = 1,
		Combat = 2,
	},

	Priorities = {
		Physic = {
			Position = 1,
			Velocity = 2,
		},

		Combat = {
			PassivesApply = 1,
			Damage = 2,
		},
	},
}

return Data
