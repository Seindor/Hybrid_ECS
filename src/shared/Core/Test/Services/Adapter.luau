local adapter = {}
adapter.__index = adapter

export type External = {
	Test: (self: External) -> (),
}

function adapter.new()
	local self = setmetatable({}, adapter)

	return self :: External
end

function adapter.Test(self: External)
	print("test")
end

return adapter
