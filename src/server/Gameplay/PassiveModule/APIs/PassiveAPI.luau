local jecs = require("@RbxPackages/jecs")
local Types = require("@SharedGameplay/PassiveModule/Data/Types")
local PassiveConstructionOperations = require("../Operations/PassiveConstructionOperations")
local PassiveOperations = require("../Operations/PassiveOperations")
local PassiveContainerOperations = require("../Operations/PassiveContainerOperations")

local API = {}

function API.AttachPassive(owner: jecs.Entity, passive: Types.Passive)
	PassiveConstructionOperations.CreateContainer(owner)
	PassiveContainerOperations.AddPassive(owner, passive)

	if PassiveContainerOperations.HasPassive(owner, passive.name) then
		PassiveOperations.ExecuteBehavior(owner, passive, "OnAttach")
	end
end

function API.DetachPassive(owner: jecs.Entity, passiveName: string)
	PassiveConstructionOperations.CreateContainer(owner)
	local selectedPassive = PassiveContainerOperations.GetPassive(owner, passiveName)
	if selectedPassive then PassiveOperations.ExecuteBehavior(owner, selectedPassive, "OnDetach") end

	PassiveContainerOperations.RemovePassive(owner, passiveName)
end

return API
