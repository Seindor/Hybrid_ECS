local jecs = require("@RbxPackages/jecs")
local Components = require("../Data/Components")
local WorldPoint = require("@SharedInternal/ECS/WorldPoint")
local Types = require("../Data/Types")

local API = {}

function API.CreateAttribute(owner: jecs.Entity, name: string, data: Types.Attribute)
	data._dirty = false
	local container = WorldPoint:get(owner, Components.AttributesContainer) or {}
	container[name] = data
	WorldPoint:set(owner, Components.AttributesContainer, container :: any)
end

function API.CreateModifier(owner: jecs.Entity, name: string, data: Types.Modifier)
	local container = WorldPoint:get(owner, Components.ModifiersContainer) or {}
	container[name] = data
	WorldPoint:set(owner, Components.ModifiersContainer, container :: any)
end

return API
