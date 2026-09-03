local Types = require("../../Data/Types")

local passive = {} :: Types.IPassiveObject

function passive.OnAttach(owner, passive)
	print("Attached Passive", passive)
end

function passive.OnTick(owner, passive)
	print("tick")
end

return passive
