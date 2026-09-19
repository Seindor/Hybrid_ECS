export type InputRecord = {
	state: Enum.UserInputState,
}

-- key: control identifier (e.g. "Q", "MouseButton1") derived from an InputObject
export type InputSnapshot = {
	[string]: InputRecord,
}

return {}