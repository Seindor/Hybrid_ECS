local jecs = require("@RbxPackages/jecs")
local PassiveConstructionOperations = require("../Operations/PassiveConstructionOperations")
local PassiveOperations = require("../Operations/PassiveOperations")
local PassiveContainerOperations = require("../Operations/PassiveContainerOperations")

local API = {}

function API.AttachPassive(owner: jecs.Entity, passiveName: string, data: { [string]: any }?)
	PassiveConstructionOperations.CreateContainer(owner)

	local passive = PassiveConstructionOperations.CreatePassive(owner, passiveName, data)
	if not passive then return end

	PassiveContainerOperations.AddPassive(owner, passive)
	PassiveOperations.ExecuteBehavior(owner, passive, "OnAttach")
end

function API.DetachPassive(owner: jecs.Entity, passiveName: string)
	PassiveConstructionOperations.CreateContainer(owner)

	local passive = PassiveContainerOperations.GetPassive(owner, passiveName)
	if passive then PassiveOperations.ExecuteBehavior(owner, passive, "OnDetach") end

	PassiveContainerOperations.RemovePassive(owner, passiveName)
	if passive then PassiveConstructionOperations.DestroyPassive(passive) end
end

return API