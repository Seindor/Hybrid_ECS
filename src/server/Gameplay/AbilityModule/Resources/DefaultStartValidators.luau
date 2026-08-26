local validators: { [string]: (...any) -> () } = {}

function validators.CheckCD()
	return true
end

function validators.CheckIsActive()
	return true
end

return validators
