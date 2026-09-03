local jecs = require("@RbxPackages/jecs")
local PassiveOperations = require("../Operations/PassiveOperations")
local PassiveContainerOperations = require("../Operations/PassiveContainerOperations")
local Types = require("../Data/Types")
local API = {}

function API.AttachPassive(owner: jecs.Entity, passive: Types.Passive)
	PassiveContainerOperations.AddPassive(owner, passive)

	if PassiveContainerOperations.HasPassive(owner, passive.name) then
		PassiveOperations.ExecuteBehavior(owner, passive, "OnAttach")
	end
end

function API.DetachPassive(owner: jecs.Entity, passiveName: string)
	local selectedPassive = PassiveContainerOperations.GetPassive(owner, passiveName)
	if selectedPassive then PassiveOperations.ExecuteBehavior(owner, selectedPassive, "OnDetach") end

	PassiveContainerOperations.RemovePassive(owner, passiveName)
end

return API
