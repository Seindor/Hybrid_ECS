local jecs = require("@RbxPackages/jecs")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local ConvertProfileOperations = require("../Resources/ConvertProfileOperations")
local ProfileDataOperations = require("../Operations/ProfileDataOperations")
local Components = require("../Data/Components")

local API = {}

function API.LoadPlayer(player: Player, entity: jecs.Entity)
	local id = tostring(player.UserId)
	local data = ProfileDataOperations.Load(id)

	if not data then
		player:Kick("Failed to load data!")
		return
	end

	ConvertProfileOperations.ConvertFromStore(entity, data)
	WorldPoint:set(entity, Components.ProfileConversion, { id = id })
end

function API.UnloadPlayer(player: Player, entity: jecs.Entity)
	local id = tostring(player.UserId)
	local data = ConvertProfileOperations.ConvertToStore(entity)
	ProfileDataOperations.Save(id, data)
	ProfileDataOperations.Unload(id)
end

return API
