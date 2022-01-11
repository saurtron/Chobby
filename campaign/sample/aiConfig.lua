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
	return ((WG.Chobby.Configuration:GetIsDevEngine() and "105") or "Dev") .. circuitDifficulties[difficultySetting]
end

function aiLibFunctions.Circuit_difficulty_autofill_ally(difficultySetting)
	return ((WG.Chobby.Configuration:GetIsDevEngine() and "105") or "Dev") .. circuitDifficultiesAlly[difficultySetting]
end

return {
	aiLibFunctions = aiLibFunctions,
}
