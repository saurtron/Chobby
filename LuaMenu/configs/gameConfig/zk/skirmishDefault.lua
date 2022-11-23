
local engineString = ((WG.Chobby.Configuration:IsCurrentVersionNewerThan(105, 900) and "1051344") or "105")

return {
	map = "TitanDuel 2.2",
	enemyAI = engineString .. "CircuitAIEasy" .. ((Configuration:GetIsRunning64Bit() and "64") or "32"),
}
