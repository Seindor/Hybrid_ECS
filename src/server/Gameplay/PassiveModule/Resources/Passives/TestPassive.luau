local Types = require("@SharedGameplay/PassiveModule/Data/Types")

local passive = {} :: Types.IPassiveObject

function passive.OnAttach(owner, passiveData)
	print("Attached Passive", passiveData)
end

function passive.OnTick(owner, passiveData)
	print(passiveData.active)
end

return passive
