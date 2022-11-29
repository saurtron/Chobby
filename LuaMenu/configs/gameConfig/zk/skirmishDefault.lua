
local AiPrefixFunc = VFS.Include(LUA_DIRNAME .. "configs/gameConfig/zk/aiPrefixFunc.lua")

return {
	map = "TitanDuel 2.2",
	enemyAI = AiPrefixFunc() .. "CircuitAIEasy" .. ((Configuration:GetIsRunning64Bit() and "64") or "32"),
}
