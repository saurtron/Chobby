local settings = {
	FontSize = 18,
	OverheadMaxHeightFactor = 1.4,
	HangTimeout = 30,
	ROAM = 1,
	SplashScreenDir = "./MenuLoadscreens",
	UseDistToGroundForIcons = 1.1,
	
	UseLuaMemPools = 0,
	VFSCacheArchiveFiles = 0,
	UnitLodDist = 999999,
	MaxTextureAtlasSizeX = 4096,
	MaxTextureAtlasSizeY = 4096,
}

local onlyIfMissingSettings = {
	FeatureDrawDistance = 600000,
	FeatureFadeDistance = 600000,
}

local onlyIfOutdated = {
	LuaGarbageCollectionMemLoadMult = 2.5,
	LuaGarbageCollectionRunTimeMult = 1.5,
}

local onlyIfValueBelow = {
	MaxTextureAtlasSizeX = 4096,
	MaxTextureAtlasSizeY = 4096,
}

local settingsVersion = 1

return settings, onlyIfMissingSettings, onlyIfOutdated, onlyIfValueBelow, settingsVersion
