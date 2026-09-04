local Types = require("@SharedGameplay/PassiveModule/Data/Types")

local passive = {} :: Types.IPassiveObject

function passive.OnAttach(_owner, passiveData)
	print("Attached Passive", passiveData)
end

function passive.OnTick(_owner, passiveData)
	print(passiveData.active)
end

return passive
