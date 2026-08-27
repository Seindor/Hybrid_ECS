local Profile = require("@Server/Internal/Dependencies/Datastores/Profile")
local Abilities = require("@Server/Internal/Dependencies/Registries/Abilities")

return {
    Datastores = {
        Profile = Profile,
    },
    Registries = {
        Abilities = Abilities,
    },
}
