local aiLibFunctions = {}

local circuitDifficulties = {
	"CircuitAIEasy",
	"CircuitAINormal",
	"CircuitAIHard",
	"CircuitAIBrutal",
}

local circuitDifficultiesAlly = {
	"CircuitAINormal",
	"CircuitAINormal",
	"CircuitAIHard",
	"CircuitAIBrutal",
}

function aiLibFunctions.Circuit_difficulty_autofill(difficultySetting)
	return ((WG.Chobby.Configuration:IsCurrentVersionNewerThan(105, 1250) and "1051344") or "105") .. circuitDifficulties[difficultySetting]
end

function aiLibFunctions.Circuit_difficulty_autofill_ally(difficultySetting)
	return ((WG.Chobby.Configuration:IsCurrentVersionNewerThan(105, 1250) and "1051344") or "105") .. circuitDifficultiesAlly[difficultySetting]
end

return {
	aiLibFunctions = aiLibFunctions,
}
