local shortname = "zk"
local backgroundImage = LUA_DIRNAME .. "configs/gameConfig/" .. shortname .. "/skinning/background.jpg"

local currentTime = os.date('*t')
if currentTime and (tonumber(currentTime.month or 0) == 10 and tonumber(currentTime.day or 0) >= 24) or (currentTime.month == 11 and currentTime.day == 1) then
	backgroundImage = LUA_DIRNAME .. "configs/gameConfig/" .. shortname .. "/skinning/background_halloween_kingstad.jpg"
end

local config = {
	backgroundFocus = {
		0.25,
		0.25,
	},
	backgroundImage = backgroundImage,
}

-- Font is "Segoe UI Semibold" at 36 pt on large images and 28 pt on small images.

return config
