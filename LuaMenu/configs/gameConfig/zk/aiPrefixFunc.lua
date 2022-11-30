
local function AiPrefixFunc()
	if WG.Chobby.Configuration:IsCurrentVersionNewerThan(105, 1380) then
		return "1051388"
	end
	if WG.Chobby.Configuration:IsCurrentVersionNewerThan(105, 900) then
		return "1051344"
	end
	return "105"
end

return AiPrefixFunc
