local Types = require("../../Gameplay/QuestsModule/Data/Types")

type Info = { [string]: Types.QuestInfoData }

local info: Info = {}

info["Test"] = {
	Name = "Test",
	DisplayName = "Test Quest",
	Description = "This is a test quest, you need to earn 100 Coins",

	Requirements = {
		["Coins"] = { kind = "Currency", attribute = "Coins", value = 100 },
	},
} :: Types.QuestInfoData

return info :: Info
