export type RequirementEntryData =
	| { kind: "Currency", attribute: string, value: number }
	| { kind: "Flag", attribute: string, value: boolean }

export type ProgressEntryData = { [string]: any }

export type QuestInfoData = {
	Name: string,
	DisplayName: string,
	Description: string,

	Requirements: { [string]: RequirementEntryData },
}

return {}
