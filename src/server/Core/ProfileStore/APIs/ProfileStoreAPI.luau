local jecs = require("@RbxPackages/jecs")
local Profile = require("@ServerInternal/Dependencies/Datastores/Profile").Resource
local ConvertProfileOperations = require("../Resources/Profile/ConvertProfileOperations")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Components = require("../Data/Components")

local API = {}

function API.LoadPlayer(player: Player, entity: jecs.Entity)
	local id = tostring(player.UserId)
	local data = Profile:Load(id)

	if not data then
		player:Kick("Failed to load data!")
		return
	end

	ConvertProfileOperations.ConvertFromStore(entity, data)
	WorldPoint:set(entity, Components.ProfileConversion, { id = id, player = player })
end

function API.UnloadPlayer(player: Player, entity: jecs.Entity)
	local id = tostring(player.UserId)
	API.SavePlayer(player, entity)
	Profile:Unload(id)
end

function API.SavePlayer(player: Player, entity: jecs.Entity)
	local id = tostring(player.UserId)
	local data = ConvertProfileOperations.ConvertToStore(entity)
	Profile:Save(id, data)
end

return API
