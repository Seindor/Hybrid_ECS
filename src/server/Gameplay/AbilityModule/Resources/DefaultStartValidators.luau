local validators: { [string]: (...any) -> () } = {}

function validators.CheckCD() end

function validators.CheckIsActive() end

return validators
