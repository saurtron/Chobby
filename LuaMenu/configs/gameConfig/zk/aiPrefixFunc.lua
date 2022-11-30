
local function AiPrefixFunc()
	return ((WG.Chobby.Configuration:IsCurrentVersionNewerThan(105, 900) and "1051344") or "105")
end

return AiPrefixFunc
