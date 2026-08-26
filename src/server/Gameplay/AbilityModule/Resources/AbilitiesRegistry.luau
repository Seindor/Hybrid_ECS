local Types = require("../Data/Types")
local Default = require("./Abilities/Default")
local TestAbility = require("./Abilities/TestAbility")
local abilities: { [string]: Types.IAbility } = {}

abilities["Default"] = Default
abilities["Test"] = TestAbility
-- ^ make automatic loader later

return abilities
