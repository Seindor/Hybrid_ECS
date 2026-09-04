local Types = require("../../Data/Types")

local passive = {} :: Types.IPassiveObject

function passive.OnAttach(owner, passiveData)
	print("Attached Passive", passiveData)
end

function passive.OnTick(owner, passiveData) end

return passive
