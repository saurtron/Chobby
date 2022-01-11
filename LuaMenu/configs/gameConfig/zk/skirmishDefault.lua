return {
	map = "TitanDuel 2.2",
	enemyAI = ((Configuration:GetIsDevEngine() and "105") or "Dev") .. "CircuitAIEasy" .. ((Configuration:GetIsRunning64Bit() and "64") or "32"),
}
